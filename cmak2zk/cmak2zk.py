import click
import logging
from kazoo.client import KazooClient
from pathlib import Path
from hashlib import md5
from ruamel.yaml import YAML
from jsonmerge import merge
import json

FORMAT = '%(asctime)-15s %(message)s'
logging.basicConfig(format=FORMAT, level=logging.INFO)

ZK_ROOT="/kafka-manager/configs"

yaml = YAML(typ='safe')


@click.command()
@click.option('--overwrite-zk/--no-overwrite-zk', "over_zk", default=True, help="should existing ZK data be rewritten on md5 difference")
@click.argument("zk_url", type=str)
@click.argument('yaml_cfg', type=click.File())
def cmak2zk(over_zk, zk_url, yaml_cfg):
    """
    Populates Zookeeper at ZK_URL with Kafka cluster configuration
    in CMAK compatible format from YAML_CFG configuration file.

    ZK_URL - myzk1:2181,myzk2:2181, etc.

    \b
    YAML_CFG - Format is equal to CMAK operator Helm chart values.
    The only section used is
    https://artifacthub.io/packages/helm/cmak-operator/cmak-operator?modal=values-schema&path=cmak.

    """
    cmak_cfg = yaml.load(yaml_cfg)['cmak']
    common_cfg = cmak_cfg['clustersCommon']

    zk = KazooClient(hosts=zk_url)
    zk.start()

    for cl in cmak_cfg['clusters']:
        cl = merge(common_cfg, cl)
        dst = f"{ZK_ROOT}/{cl['name']}"
        json_b = json.dumps(cl, separators=(',', ':')).encode()

        if zk.exists(dst):
            file_md5 = md5(json_b).hexdigest()

            zk_b, stat = zk.get(dst)
            zk_md5 = md5(zk_b).hexdigest()
            logging.info(f"md5 of {dst}: {zk_md5}, md5 of {cl['name']}: {file_md5}")

            if zk_md5 != file_md5 and over_zk is True:
                zk.set(dst, json_b)
                logging.info(f"Overwritten {dst} from {yaml_cfg.name}")
        else:
            zk.create(dst, json_b, makepath=True)
            logging.info(f"Created {dst} from {yaml_cfg.name}")

    zk.stop()

if __name__ == "__main__":
    cmak2zk()

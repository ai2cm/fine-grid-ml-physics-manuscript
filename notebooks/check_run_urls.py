import fsspec
import yaml

def main():
    fs = fsspec.filesystem('gs')

    with open('run_urls.yaml') as f:
        runs = yaml.safe_load(f)
    
    a_run_is_missing = False

    for name, run in runs.items():
        if fs.exists(run['url'] + '/fv3config.yml'):
            print(name + ' OK')
        else:
            print(name + ' MISSING')
            a_run_is_missing = True

    if a_run_is_missing:
        print('WARNING: a run was missing. Check URLs.')


if __name__ == "__main__":
    main()
_default:
  just -l

update:
  helm package zoo
  mkdir -p ./temp
  rm -r ./temp/* || true
  mv zoo-*.tgz ./temp

[working-directory: "zoo"]
build:
  helm dependency build

alias i := install
[working-directory: "zoo"]
install ns:
  #!/usr/bin/env bash
  set -a; source ../.env; set +a
  helm install zoo-{{ns}} . -n {{ns}} \
    -f ./values.yaml \
    -f ../../values/values-{{ns}}.yaml \
    --set global.ghcrSecret.enabled=true \
    --set global.ghcrSecret.password=$CR_PAT \
    --set zoo-backend.mongo.root.user=$MONGO_ROOT \
    --set zoo-backend.mongo.root.password=$MONGO_ROOT_PASS \
    --set zoo-mongo.auth.rootUser=$MONGO_ROOT \
    --set zoo-mongo.auth.rootPassword=$MONGO_ROOT_PASS

alias u := uninstall
uninstall ns:
  helm uninstall zoo-{{ns}} -n {{ns}}

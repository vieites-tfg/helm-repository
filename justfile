_default:
  just -l

update:
  helm package zoo
  mkdir -p ./temp
  rm -r ./temp/* || true
  mv zoo-*.tgz ./temp

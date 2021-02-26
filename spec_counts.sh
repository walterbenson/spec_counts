#!/bin/sh

FILE_NAME=spec_counts_log.csv
cd ../spec_counts
printf "repo, running, skipped, date\n" > $FILE_NAME

REPOS=( selenium-finance api-tests contract-api-tests selenium-tests selenium-pro-reg fintech-onboarding-ui-tests )
for REPO in "${REPOS[@]}"
do
  cd ../$REPO
  pwd
  git checkout main
  git pull origin main
  bundle install
  OUTPUT=$(bundle exec rspec --dry-run --no-color | grep 'examples, 0 failures')

  RUNNING=$(echo $OUTPUT | cut -d ' ' -f 1)
  SKIPPED=$(echo $OUTPUT | cut -d ' ' -f 5)
  NOW=$(date +'%Y-%m-%d')
  cd ../spec_counts
  printf "$REPO, $RUNNING, $SKIPPED, $NOW\n" >> $FILE_NAME
done

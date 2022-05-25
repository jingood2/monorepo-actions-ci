# read the workflow template
SAM_WORKFLOW_TEMPLATE=$(cat .github/sam-cicd-template.yaml)
CD_WORKFLOW_TEMPLATE=$(cat .github/multi-account-cd-template.yml)

cp .github/multi-account-cd-template.yml /tmp/multi-account-cd.yml
CD_WORKFLOW_TEMP=$(cat /tmp/multi-account-cd.yml)

cp .github/multi-account-reusable-cd-template.yml /tmp/multi-account-reusable-cd.yml

BUILD_ACCOUNT='037729278610'
TARGET_DEPLOY_ACCOUNTS=('037729278610' '123429278610')

# ACCOUNT 수만큼 reusable template에 deploy-prod 추가
for ACCOUNT in ${TARGET_DEPLOY_ACCOUNTS[@]}; do

    if [ ${ACCOUNT} == ${BUILD_ACCOUNT} ];
    then
        CD_WORKFLOW=$(echo "${CD_WORKFLOW_TEMP}" | sed "s/{{STAGE}}/dev/g")
    else
        CD_WORKFLOW=$(echo "${CD_WORKFLOW_TEMP}" | sed "s/{{STAGE}}/prod/g")
    fi

    CD_WORKFLOW=$(echo "${CD_WORKFLOW}" | sed "s/{{ACCOUNT}}/${ACCOUNT}/g")
    echo "${CD_WORKFLOW}" >> /tmp/multi-account-reusable-cd.yml
done

MULTI_ACCOUNT_WORKFLOW_TEMPLATE=$(cat /tmp/multi-account-reusable-cd.yml)
#MULTI_ACCOUNT_WORKFLOW_TEMPLATE=$(cat .github/multi-account-reusable-cd-template.yml)

for ROUTE in $(ls projects); do
    echo "generating workflow for projects/${ROUTE}"

   

    # replace template route placeholder with route name
    #WORKFLOW=$(echo "${SAM_WORKFLOW_TEMPLATE}" | sed "s/{{ROUTE}}/${ROUTE}/g")
    WORKFLOW=$(echo "${MULTI_ACCOUNT_WORKFLOW_TEMPLATE}" | sed "s/{{ROUTE}}/${ROUTE}/g")

    # save workflow to .github/workflows/{ROUTE}
    echo "${WORKFLOW}" > .github/workflows/${ROUTE}.yaml
done

#iterate each route in routes directory
#for ROUTE in $(ls projects); do
#    echo "generating workflow for projects/${ROUTE}"
#
#    # replace template route placeholder with route name
#    WORKFLOW=$(echo "${MULTI_ACCOUNT_WORKFLOW_TEMPLATE}" | sed "s/{{ROUTE}}/${ROUTE}/g")
#
#    # save workflow to .github/workflows/{ROUTE}
#    echo "${WORKFLOW}" > .github/workflows/${ROUTE}.yaml
#done
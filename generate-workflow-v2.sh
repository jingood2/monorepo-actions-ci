# read the workflow template
WORKFLOW_TEMPLATE=$(cat .github/workflow-template.yaml)
SAM_WORKFLOW_TEMPLATE=$(cat .github/sam-cicd-template.yaml)
MULTI_ACCOUNT_WORKFLOW_TEMPLATE=$(cat .github/multi-account-deploy-template.yml)
CD_WORKFLOW_TEMPLATE=$(cat .github/lambda-cd-template.yml)

TARGET_DEPLOY_ACCOUNTS=('037729278610' '123429278610')

# ACCOUNT 수만큼 reusable template에 deploy-prod 추가
for ACCOUNT in ${TARGET_DEPLOY_ACCOUNTS[@]}; do
    CD_WORKFLOW=$(echo "${CD_WORKFLOW_TEMPLATE}" | sed "s/{{ACCOUNT}}/${ACCOUNT}/g")
    echo "${CD_WORKFLOW}" >> .github/workflows/reusable-lambda-ci.yml
done

for ROUTE in $(ls projects); do
    echo "generating workflow for projects/${ROUTE}"

    # replace template route placeholder with route name
    #WORKFLOW=$(echo "${SAM_WORKFLOW_TEMPLATE}" | sed "s/{{ROUTE}}/${ROUTE}/g")
    WORKFLOW=$(echo "${MULTI_ACCOUNT_WORKFLOW_TEMPLATE}" | sed "s/{{ROUTE}}/${ROUTE}/g")
    WORKFLOW=$(echo "${WORKFLOW}" | sed "s/{{ACCOUNT}}/${ACCOUNT}/g")

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
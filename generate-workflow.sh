# read the workflow template
WORKFLOW_TEMPLATE=$(cat .github/workflow-template.yaml)
SAM_WORKFLOW_TEMPLATE=$(cat .github/sam-cicd-template.yaml)
MULTI_ACCOUNT_WORKFLOW_TEMPLATE=$(cat .github/multi-account-reusable-cd-template.yml)

TARGET_DEPLOY_ACCOUNTS=('037729278610' '123429278610')

for ACCOUNT in ${TARGET_DEPLOY_ACCOUNTS[@]}; 
    for ROUTE in $(ls projects); do
        echo "generating workflow for projects/${ROUTE}"

        # replace template route placeholder with route name
        #WORKFLOW=$(echo "${SAM_WORKFLOW_TEMPLATE}" | sed "s/{{ROUTE}}/${ROUTE}/g")
        WORKFLOW=$(echo "${MULTI_ACCOUNT_WORKFLOW_TEMPLATE}" | sed "s/{{ROUTE}}/${ROUTE}/g")
        WORKFLOW=$(echo "${WORKFLOW}" | sed "s/{{ACCOUNT}}/${ACCOUNT}/g")

        # save workflow to .github/workflows/{ROUTE}
        mkdir -p .github/workflows/${ACCOUNT}
        echo "${WORKFLOW}" > .github/workflows/${ACCOUNT}/${ROUTE}.yaml
    done
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
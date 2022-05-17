# read the workflow template
WORKFLOW_TEMPLATE=$(cat .github/workflow-template.yaml)
SAM_WORKFLOW_TEMPLATE=$(cat .github/sam-cicd-template.yaml)

# iterate each route in routes directory
for ROUTE in $(ls projects); do
    echo "generating workflow for projects/${ROUTE}"

    # replace template route placeholder with route name
    WORKFLOW=$(echo "${SAM_WORKFLOW_TEMPLATE}" | sed "s/{{ROUTE}}/${ROUTE}/g")

    # save workflow to .github/workflows/{ROUTE}
    echo "${WORKFLOW}" > .github/workflows/${ROUTE}.yaml
done
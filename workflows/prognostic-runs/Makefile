kustomize:
	../install_kustomize.sh 3.10.0

deploy: kustomize
	./kustomize build . | kubectl apply -f -

prognostic_%: deploy
	./$*.sh

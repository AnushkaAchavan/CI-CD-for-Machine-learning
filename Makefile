
install:
	python -m pip install --upgrade pip
	python -m pip install -r requirements.txt

format:
	python -m black *.py

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md
	echo "" >> report.md
	echo "## Confusion Matrix Plot" >> report.md
	echo "![Confusion Matrix](./Results/model_results.png)" >> report.md
	cml comment create report.md

update-branch:
	git config user.name "$(USER_NAME)"
	git config user.email "$(USER_EMAIL)"
	git add Model Results
	git commit --allow-empty -m "Update with new results"
	git push origin HEAD:update

hf-login:
	hf auth login --token "$(HF)"

push-hub:
	hf upload AnushkaChavan/Drug-classification ./App/ .
	hf upload AnushkaChavan/Drug-classification ./Model/ Model/
	hf upload AnushkaChavan/Drug-classification ./Results/ Results/

deploy: hf-login push-hub

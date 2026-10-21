
install:
	pip install --upgrade pip && \
		pip install -r requirements.txt

format:
	black *.py

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
	git config --global user.name $(USER_NAME)
	git config --global user.email $(USER_EMAIL)
	git commit --allow-empty -am "Update with new results"
	git push --force origin HEAD:update

hf-login:
	git pull origin update
	git switch update
	hf auth login --token $(HF)

push-hub:
	hf upload AnushkaChavan/Drug-classification ./App .
	hf upload AnushkaChavan/Drug-classification ./Model Model
	hf upload AnushkaChavan/Drug-classification ./Results Results

deploy: hf-login push-hub

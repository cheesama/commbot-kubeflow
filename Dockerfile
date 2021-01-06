FROM gcr.io/kubeflow-images-public/tensorflow-2.1.0-notebook-gpu:1.0.0

USER root
RUN pip uninstall -y enum34
RUN chmod 777 -R /home/jovyan
RUN pip install --upgrade torch pytorch-lightning jupyterlab kfp
RUN pip install --upgrade papermill elyra && jupyter lab build

USER jovyan

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/${NB_USER} --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]

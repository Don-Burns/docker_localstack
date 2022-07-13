conda env create --no-default-packages -f env.yml -n py_env && conda-pack -n py_env -o py_env.tar.gz

conda env remove -n py_env && rm py_env.tar.gz
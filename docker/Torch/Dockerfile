FROM kaixhin/torch

RUN luarocks install nngraph
RUN luarocks install class
RUN luarocks install https://raw.githubusercontent.com/szym/display/master/display-scm-0.rockspec

RUN apt-get install wget

CMD ["jupyter", "notebook", "--allow-root", "--ip=0.0.0.0", "--no-browser"]

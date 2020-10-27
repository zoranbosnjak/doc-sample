{ pkgs }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "sphinx";
  version = "3.2.1";
  src = pkgs.python3Packages.fetchPypi {
    pname = "Sphinx";
    inherit version;
    sha256 = "1s70hxhddzf656kmj01lws4cbywgsinbg8750r9ilf7s2sdns79j";
  };
  propagatedBuildInputs = with pkgs.python3Packages; [
    sphinxcontrib-applehelp
    sphinxcontrib-devhelp
    sphinxcontrib-jsmath
    sphinxcontrib-htmlhelp
    sphinxcontrib-serializinghtml
    sphinxcontrib-qthelp
    jinja2
    pygments
    docutils
    snowballstemmer
    Babel
    alabaster
    imagesize
    requests
    setuptools
    packaging
  ];
  doCheck = false;
}


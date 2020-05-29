{ stdenv, fetchFromGitHub, cmake, ninja, llvm_10, clang_10, python3 }:

let
  llvm = llvm_10;
  clang = clang_10;
in

stdenv.mkDerivation rec {
  pname = "libclc";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "llvmorg-${version}";
    sha256 = "1mhr0yhbz5w5mv4gk3jpcz12d3k2mvm6qi276fx4bw21q3vs2z4q";
  };

  nativeBuildInputs = [ cmake ninja python3 ];
  buildInputs = [ llvm clang ];

  postUnpack = "sourceRoot=\${sourceRoot}/libclc";

  cmakeFlags = [
    "-DLLVM_CLANG=${clang}/bin/clang"
    "-DLLVM_CONFIG=${llvm}/bin/llvm-config"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://libclc.llvm.org/";
    description = "Implementation of the library requirements of the OpenCL C programming language";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {

    packages = [
        pkgs.python3
        (pkgs.python3.withPackages(p: with p; [
            python-pptx
            pdf2image
        ]))
    ];
}

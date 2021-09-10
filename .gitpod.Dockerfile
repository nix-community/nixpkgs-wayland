FROM gitpod/workspace-base

USER root

RUN addgroup --system nixbld \
  && adduser gitpod nixbld \
  && for i in $(seq 1 30); do useradd -ms /bin/bash nixbld$i &&  adduser nixbld$i nixbld; done \
  && mkdir -m 0755 /nix && chown gitpod /nix \
  && mkdir -p /etc/nix \
    && echo 'sandbox = false' >> /etc/nix/nix.conf \
    && echo 'experimental-features = nix-command flakes' >> /etc/nix/nix.conf

CMD /bin/bash -l
USER gitpod
ENV USER gitpod
WORKDIR /home/gitpod

RUN mkdir -p /home/gitpod/.bashrc.d && touch .bash_profile \
  && curl -L "https://github.com/numtide/nix-unstable-installer/releases/download/nix-2.4pre20210823_af94b54/install" | sh

RUN echo '. /home/gitpod/.nix-profile/etc/profile.d/nix.sh' >> /home/gitpod/.bashrc

# TODO: replace the --from-expression line with `nix-direnv-flakes` when possible
RUN . /home/gitpod/.nix-profile/etc/profile.d/nix.sh \
  && nix-env -iA nixpkgs.git nixpkgs.git-lfs nixpkgs.direnv \
  && nix-env -iA --from-expression 'f: with import <nixpkgs> {}; pkgs.nix-direnv.override {enableFlakes=true;}' \
  && direnv hook bash >> /home/gitpod/.bashrc \
  && echo "source $HOME/.nix-profile/share/nix-direnv/direnvrc" >> /home/gitpod/.direnvrc \
  && nix-env -iA cachix -f https://cachix.org/api/v1/install

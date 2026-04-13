{ denTest, ... }:
{
  flake.tests.bogus = {

    test-minimal-mixed-merge = denTest (
      {
        den,
        lib,
        igloo,
        ...
      }:
      {
        den.hosts.x86_64-linux.igloo.users.tux = { };

        imports =
          let
            # Bare function at _.sub
            fn-def = {
              den.aspects.bar._.sub = { host, ... }: {
                nixos.networking.hostName = host.hostName;
              };
            };

            # Plain attrset at the SAME _.sub
            attrset-def = {
              den.aspects.bar._.sub.nixos.programs.vim.enable = true;
            };
          in
          [ fn-def attrset-def ];

        den.aspects.igloo.includes = [ den.aspects.bar._.sub ];

        expr = {
          hostname = igloo.networking.hostName;
          vim = igloo.programs.vim.enable;
        };
        expected = {
          hostname = "igloo";
          vim = true;
        };
      }
    );

  };
}

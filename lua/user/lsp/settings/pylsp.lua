return {
    settings = {
        pylsp = {
            plugins = {
                -- disabled here because using null-ls (black)
                yapf = {
                    enabled = false,
                },
                autopep8 = {
                    enabled = false,
                },
                -- flake8 is a combination of pyflakes,
                -- pycodestyle, and mccabe.
                -- I only want pycodestyle.
                flake8 = {
                    enabled = false,
                    maxLineLength = 100,
                    ignore = {
                        "W391"
                    }
                },
                pycodestyle = {
                    enabled = false,
                    maxLineLength = 100,
                    ignore = {
                        -- E113 double reporting
                        "E113",
                        "E203",
                        "E221",
                        "E222",
                        "W292",
                        "W391",
                        "W503",
                    },
                },
                pyflakes = {
                    enabled = false,
                },
                mccabe = {
                    enabled = false,
                }
            }
        }
    }
}

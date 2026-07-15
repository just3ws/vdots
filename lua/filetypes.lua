vim.filetype.add {
  extension = {
    lst = "text",
    gotmpl = "gotmpl",
    bpmn = "xml",
  },
  filename = {
    ["go.work"] = "gowork",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
    [".gitlab-ci.yml"] = "yaml.gitlab",
    [".mdlrc"] = "ruby",
    [".env"] = "sh",
    [".erdconfig"] = "yaml",
    [".eslintignore"] = "gitignore",
    [".npmignore"] = "gitignore",
    [".prettierignore"] = "gitignore",
    [".jscsrc"] = "json",
    [".jshintrc"] = "json",
    [".eslintrc"] = "json",
    [".prettierrc"] = "json",
    [".releaserc"] = "json",
  },
  pattern = {
    ["%.env%..*"] = "sh",
  },
}

vim.filetype.add {
  extension = {
    lst = "text",
    gotmpl = "gotmpl",
  },
  filename = {
    ["go.work"] = "gowork",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
    [".gitlab-ci.yml"] = "yaml.gitlab",
  },
}

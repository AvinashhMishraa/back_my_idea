json.array!(@project_choices) do |project|
  json.title project.title
  json.url projects_path(project)
end
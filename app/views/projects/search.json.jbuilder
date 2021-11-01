json.array!(@all_projects) do |project|
  json.title project.title
  json.url projects_path(project)
end
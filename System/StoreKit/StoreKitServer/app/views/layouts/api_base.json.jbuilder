# based on JSON API v.1
if @errors.length > 0
  json.errors @errors
else
  json.data yield
end

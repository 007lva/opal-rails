LAYOUT = <<-HTML
<!DOCTYPE html>
<html>
<head><%= javascript_include_tag "application" %></head>
<body><%= yield %></body>
</html>
HTML

INDEX = <<-HTML
<script type="text/ruby">
raise 'pippo'
</script>
HTML

WITH_ASSIGNMENTS = <<-RUBY
return {
  number_var: @number_var,
  string_var: @string_var,
  array_var:  @array_var,
  hash_var:   @hash_var,
  object_var: @object_var,
  local_var:  defined?(local_var) ? local_var : nil
}.to_n
RUBY

class ApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers
  layout 'application'
  self.view_paths = [ActionView::FixtureResolver.new(
    'layouts/application.html.erb'         => LAYOUT,
    'application/index.html.erb'           => INDEX,
    'application/with_assignments.js.opal' => WITH_ASSIGNMENTS,
  )]

  def index
  end

  def with_assignments
    object = Object.new
    def object.as_json options = {}
      {contents: 'json representation'}
    end

    @number_var = 1234
    @string_var = 'hello'
    @array_var  = [1,'a']
    @hash_var   = {a: 1, b: 2}
    @object_var = object

    render type: :js, locals: { local_var: 'i am local' }
  end
end

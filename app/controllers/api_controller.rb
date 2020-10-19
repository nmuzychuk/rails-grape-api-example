class ApiController < Grape::API
  version 'v1', using: :path, vendor: 'vendor'
  prefix :api
  format :json

  before do
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'
  end

  mount BooksController
  add_swagger_documentation \
  info: {
      title: "Books API"
  }
end

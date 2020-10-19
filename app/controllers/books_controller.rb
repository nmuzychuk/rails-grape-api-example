class BooksController < Grape::API
  resource :books do
    desc 'Returns all books.'
    get do
      Book.all
    end

    desc 'Searches a book using www.googleapis.com.'
    params do
      requires :q, type: String, desc: 'Search query.'
    end
    get :search do
      Book.search(params[:q])
    end

    desc 'Returns a book.'
    params do
      requires :id, type: Integer, desc: 'Book ID.'
    end
    route_param :id do
      get do
        Book.find(params[:id])
      end
    end

    desc 'Creates a book.'
    params do
      requires :book, type: Hash, desc: 'Your book.' do
        requires :title, type: String, desc: 'Book title'
        optional :description, type: String, desc: 'Book description'
        optional :page_count, type: Integer, desc: 'Number of pages'
      end
      requires :publisher, type: Hash, desc: 'Book publisher' do
        requires :name, type: String, desc: 'Publisher name'
      end
      optional :categories, type: Array, desc: 'List of category names.',
               documentation: {param_type: 'body'} do
      end
    end
    post do
      categories = []
      params[:categories]&.each { |c| categories << Category.find_or_create_by(name: c) }
      publisher = Publisher.find_or_create_by!(params[:publisher])
      Book.create!(params[:book].merge(publisher: publisher, category_ids: categories.collect(&:id)))
    end

    desc 'Updates a book.'
    params do
      requires :book, type: Hash, desc: 'Your book.' do
        optional :title, type: String, desc: 'Book title'
        optional :description, type: String, desc: 'Book description'
        optional :page_count, type: Integer, desc: 'Number of pages'
      end
    end
    put ':id' do
      Book.update(params[:id], params[:book])
    end

    desc 'Deletes a book.'
    params do
      requires :id, type: String, desc: 'Book ID.'
    end
    delete ':id' do
      Book.find(params[:id]).destroy
    end
  end
end

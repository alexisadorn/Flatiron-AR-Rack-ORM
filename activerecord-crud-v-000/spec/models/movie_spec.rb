describe 'Movie' do
  let(:attributes) {{
      title: "The Sting",
      release_date: 1973,
      director: "George Roy Hill",
      lead: "Paul Newman",
      in_theaters: false
  }}

  it 'inherits from ActiveRecord::Base' do
    expect(Movie.superclass).to eq(ActiveRecord::Base)
  end

  context 'Movie.new' do
    let(:movie) { Movie.new }
    it 'has a title' do
      movie.title = "The Matrix"
      expect(movie.title).to eq("The Matrix")
    end

    it 'has a release date' do
      movie.release_date = 1999
      expect(movie.release_date).to eq(1999)
    end

    it 'has a director' do
      movie.director = "The Wachowski Brothers"
      expect(movie.director).to eq("The Wachowski Brothers")
    end

    it 'has a lead actor/actress' do
      movie.lead = "Keanu Reeves"
      expect(movie.lead).to eq("Keanu Reeves")
    end

    it 'has an in theaters flag' do
      movie.in_theaters = false
      expect(movie.in_theaters?).to be_falsey
    end
  end

  context '::new' do
    it 'can be instantiated without any attributes' do
      expect{Movie.new}.to_not raise_error
    end

    it 'can be instantiated with a hash of attributes' do
      expect{Movie.new(attributes)}.to_not raise_error
    end
  end

  context '#save' do
    it 'can be saved to the database' do
      movie = Movie.new(attributes)
      movie.save
      expect(Movie.find_by(attributes)).to eq(movie)
    end
  end

  context 'basic CRUD' do
    context 'creating' do
      it 'can be instantiated and then saved' do
        can_be_instantiated_and_then_saved
        expect(Movie.find_by(title: "This is a title.").title).to eq("This is a title.")
      end

      it 'can be created with a hash of attributes' do
        movie = can_be_created_with_a_hash_of_attributes
        expect(Movie.find_by(attributes)).to eq(movie)
      end

      it 'can be created in a block' do
        movie = can_be_created_in_a_block

        expect(Movie.last).to eq(movie)
        expect(Movie.last.title).to eq("Home Alone")
        expect(Movie.last.release_date).to eq(1990)
      end
    end

    context 'reading' do
      before do
        5.times do |i|
          Movie.create(title: "Movie_#{i}", release_date: i+2000)
        end
      end

      it 'can get the first item in the database' do
        movie = can_get_the_first_item_in_the_database
        expect(movie).to eq("Movie_0")
      end

      it 'can get the last item in the databse' do
        movie = can_get_the_last_item_in_the_database
        expect(movie).to eq("Movie_4")
      end

      it 'can get size of the database' do
        movies_size = can_get_size_of_the_database
        expect(movies_size).to eq(5)
      end

      it 'can retrive the first item from the database by id' do
        expect(can_find_the_first_item_from_the_database_using_id).to eq("Movie_0")
      end

      it 'can retrieve from the database using different attributes' do
        movie = Movie.create(title: "Title", release_date: 2000, director: "Me")
        expect(can_find_by_multiple_attributes).to eq(movie)
      end

      it 'can use a where clause and be sorted' do
        expect(can_find_using_where_clause_and_be_sorted.map{|m| m.title}).to eq(["Movie_4", "Movie_3"])
      end
    end

    context 'updating' do
      it 'can be found, updated, and saved' do
        movie = Movie.create(title: "Awesome Flick")
        expect {
          can_be_found_updated_and_saved
          movie.reload
        }.to change{ movie.title }.from("Awesome Flick").to("Even Awesomer Flick")
      end

      it 'can be updated using #update' do
        can_update_using_update_method
        expect(Movie.find_by(title: "Wat, huh?")).to_not be_nil
      end

      it 'can update all records at once' do
        can_update_multiple_items_at_once
        expect(Movie.where(title: "A Movie").size).to eq(5)
      end
    end

    context 'destroying' do
      it 'can destroy a single item' do
        can_destroy_a_single_item
        expect(Movie.find_by(title: "That One Where the Guy Kicks Another Guy Once")).to be_nil
      end

      it 'can destroy all items at once' do
        can_destroy_all_items_at_once
        expect(Movie.all.size).to eq(0)
      end
    end
  end
end

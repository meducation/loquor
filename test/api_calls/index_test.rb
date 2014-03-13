require File.expand_path('../../test_helper', __FILE__)

module Loquor
  class ApiCall::IndexTest < Minitest::Test
    def resource
      r = Resource
      r.stubs(path: "http://foobar.com")
      r
    end

    def test_select_sets_criteria
      fields = [:cat, :dog]
      searcher = ApiCall::Index.new(resource).select(fields)
      assert_equal({fields: fields}, searcher.criteria)
    end

    def test_order_sets_order
      order = :random
      searcher = ApiCall::Index.new(resource).order(order)
      assert_equal(order, searcher.instance_variable_get("@order"))
    end

    def test_limit_sets_per
      per = 892
      searcher = ApiCall::Index.new(resource).limit(per)
      assert_equal(per, searcher.instance_variable_get("@per"))
    end

    def test_per_sets_per
      per = 542
      searcher = ApiCall::Index.new(resource).per(per)
      assert_equal(per, searcher.instance_variable_get("@per"))
    end

    def test_page_set_page
      page = 542
      searcher = ApiCall::Index.new(resource).page(page)
      assert_equal(page, searcher.instance_variable_get("@page"))
    end

    def test_where_sets_clauses
      clause = "WHERE 1 = 1"
      searcher = ApiCall::Index.new(resource).where(clause)
      assert_equal([clause], searcher.clauses)
    end

    def test_where_sets_criteria
      criteria = {genre: 'Animation'}
      searcher = ApiCall::Index.new(resource).where(criteria)
      assert_equal({genre: 'Animation'}, searcher.criteria)
    end

    def test_where_merges_criteria
      criteria1 = {genre: 'Animation'}
      criteria2 = {foobar: 'Cat'}
      searcher = ApiCall::Index.new(resource).where(criteria1).where(criteria2)
      assert_equal({genre: 'Animation', foobar: 'Cat'}, searcher.criteria)
    end

    def test_where_overrides_criteria_with_same_key
      criteria1 = {genre: 'Animation'}
      criteria2 = {genre: 'Action'}
      searcher = ApiCall::Index.new(resource).where(criteria1).where(criteria2)
      assert_equal({genre: "Action"}, searcher.criteria)
    end

    def test_where_gets_correct_url_with_clauses
      searcher = ApiCall::Index.new(resource).where("WHERE 1=1")
      assert searcher.send(:generate_url).include? "?clauses[]=WHERE%201=1"
    end

    def test_where_gets_correct_url_with_crtieria
      searcher = ApiCall::Index.new(resource).where(name: 'Star Wars')
      assert searcher.send(:generate_url).include? "?name=Star%20Wars"
    end

    def test_where_gets_correct_url_with_symbol
      searcher = ApiCall::Index.new(resource).where(name: :star)
      assert searcher.send(:generate_url).include? "?name=star"
    end

    def test_where_gets_correct_url_with_date
      searcher = ApiCall::Index.new(resource).where(name: Date.new(1969,5,10))
      assert searcher.send(:generate_url).include? "?name=1969-05-10"
    end

    def test_where_gets_correct_url_with_time
      searcher = ApiCall::Index.new(resource).where(name: Time.new(1969,5,10,13,10))
      assert searcher.send(:generate_url).include? "?name=1969-05-10%2013:10:00"
    end

    def test_where_gets_correct_url_with_date_time
      searcher = ApiCall::Index.new(resource).where(name: DateTime.new(1969,5,10,13,10))
      assert searcher.send(:generate_url).include? "?name=1969-05-10T13:10:00"
    end

    def test_where_gets_correct_url_with_number
      searcher = ApiCall::Index.new(resource).where(name: 1)
      assert searcher.send(:generate_url).include? "?name=1"
    end

    def test_where_gets_correct_url_with_hashed_symbols
      searcher = ApiCall::Index.new(resource).where(name: [:star, :wars])
      assert searcher.send(:generate_url).include? "?name[]=star&name[]=wars"
    end

    def test_where_gets_correct_url_with_hashed_integers
      searcher = ApiCall::Index.new(resource).where(name: [1,2])
      assert searcher.send(:generate_url).include? "?name[]=1&name[]=2"
    end

    def test_where_works_with_array_in_a_hash
      criteria = {thing: ['foo', 'bar']}
      searcher = ApiCall::Index.new(resource).where(criteria)
      assert_equal criteria, searcher.criteria
    end

    def test_generates_url_correctly_with_array_in_a_hash
      criteria = {thing: ['foo', 'bar']}
      searcher = ApiCall::Index.new(resource).where(criteria)
      searcher.stubs(path: "foobar")
      url = searcher.send(:generate_url)
      assert url.include?("thing[]=foo")
      assert url.include?("thing[]=bar")
    end

    def test_generates_url_correctly_with_hash_in_a_hash
      criteria = {thing: {foo: 'bar', cat: 'dog'}}
      searcher = ApiCall::Index.new(resource).where(criteria)
      searcher.stubs(path: "foobar")
      url = searcher.send(:generate_url)
      assert url.include?("thing[foo]=bar")
      assert url.include?("thing[cat]=dog")
    end

    def test_uses_correct_replacement_strings_in_query
      Loquor.config.substitute_values[true] = ":__true__"
      criteria = {thing: true}
      searcher = ApiCall::Index.new(resource).where(criteria)
      searcher.stubs(path: "foobar")
      url = searcher.send(:generate_url)
      assert url.include?("thing=:__true__")
    end

    def test_that_iterating_calls_results
      searcher = ApiCall::Index.new(resource).where(name: "star_wars")
      searcher.expects(results: [])
      searcher.each { }
    end

    def test_that_iterating_calls_each
      Loquor.expects(:get).returns([{id: 8, name: "Star Wars"}])
      searcher = ApiCall::Index.new(resource).where(name: "star_wars")
      searcher.send(:results).expects(:each)
      searcher.each { }
    end

    def test_search_should_set_results
      expected_results = [{id: 8, name: "Star Wars"}]
      Loquor.expects(:get).returns(expected_results)

      resources = ApiCall::Index.new(resource).where(name: "star_wars").to_a
      assert_equal 8, resources.first.id
      assert_equal 'Star Wars', resources.first.name
    end

    def test_search_should_create_a_results_object
      Loquor.expects(:get).returns([{id: 8, name: "Star Wars"}])
      searcher = ApiCall::Index.new(resource).where(name: "star_wars")
      searcher.to_a
      assert Array, searcher.instance_variable_get("@results").class
    end

    def test_find_each_calls_block_for_each_item
      searcher = ApiCall::Index.new(Resource)
      Loquor.expects(:get).returns([{'id' => 8}, {'id' => 10}])

      ids = []
      searcher.find_each do |json|
        ids << json.id
      end
      assert_equal [8,10], ids
    end

    def test_find_each_limits_to_200
      searcher = ApiCall::Index.new(resource)
      Loquor.expects(:get).with("http://foobar.com?&page=1&per=200").returns([])
      searcher.find_each {}
    end

    def test_find_each_runs_multiple_times
      searcher = ApiCall::Index.new(resource)
      results = 200.times.map{""}
      Loquor.expects(:get).with("http://foobar.com?&page=1&per=200").returns(results)
      Loquor.expects(:get).with("http://foobar.com?&page=2&per=200").returns([])
      searcher.find_each {}
    end

    def test_find_each_objects_are_representations
      searcher = ApiCall::Index.new(resource)
      Loquor.expects(:get).returns([{'id' => 8}, {'id' => 10}])
      searcher.find_each do |rep|
        assert rep.is_a?(Resource)
      end
    end

    def test_objects_are_representations
      index = ApiCall::Index.new(Resource)
      Loquor.stubs(get: [{foo: 'bar'}, {cat: 'dog'}])
      results = index.send(:results)
      assert results.is_a?(Array)
      assert results[0].is_a?(Resource)
      assert results[1].is_a?(Resource)
    end

    def test_generates_url_correctly_with_order
      order = :random
      searcher = ApiCall::Index.new(resource).order(order)
      searcher.stubs(path: "foobar")
      url = searcher.send(:generate_url)
      assert url.include?("order=#{order}")
    end

    def test_generates_url_correctly_with_per
      per = 123
      searcher = ApiCall::Index.new(resource).per(per)
      searcher.stubs(path: "foobar")
      url = searcher.send(:generate_url)
      assert url.include?("per=#{per}")
    end

    def test_generates_url_correctly_with_page
      page = 45
      searcher = ApiCall::Index.new(resource).page(page)
      searcher.stubs(path: "foobar")
      url = searcher.send(:generate_url)
      assert url.include?("page=#{page}")
    end
  end
end

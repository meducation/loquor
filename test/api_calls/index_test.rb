require File.expand_path('../../test_helper', __FILE__)

module Loquor
  class ApiCall::IndexTest < Minitest::Test
    def test_where_sets_criteria
      criteria = {genre: 'Animation'}
      searcher = ApiCall::Index.new('').where(criteria)
      assert_equal({genre: 'Animation'}, searcher.criteria)
    end

    def test_where_merges_criteria
      criteria1 = {genre: 'Animation'}
      criteria2 = {foobar: 'Cat'}
      searcher = ApiCall::Index.new('').where(criteria1).where(criteria2)
      assert_equal({genre: 'Animation', foobar: 'Cat'}, searcher.criteria)
    end

    def test_where_overrides_criteria_with_same_key
      criteria1 = {genre: 'Animation'}
      criteria2 = {genre: 'Action'}
      searcher = ApiCall::Index.new('').where(criteria1).where(criteria2)
      assert_equal({genre: "Action"}, searcher.criteria)
    end

    def test_where_gets_correct_url
      searcher = ApiCall::Index.new('').where(name: 'Star Wars')
      assert searcher.send(:generate_url).include? "?name=Star%20Wars"
    end

    def test_where_works_with_array_in_a_hash
      criteria = {thing: ['foo', 'bar']}
      searcher = ApiCall::Index.new('').where(criteria)
      assert_equal criteria, searcher.criteria
    end

    def test_that_iterating_calls_results
      searcher = ApiCall::Index.new('').where(name: "star_wars")
      searcher.expects(results: [])
      searcher.each { }
    end

    def test_that_iterating_calls_each
      Loquor.expects(:get).returns([{id: 8, name: "Star Wars"}])
      searcher = ApiCall::Index.new('').where(name: "star_wars")
      searcher.send(:results).expects(:each)
      searcher.each { }
    end

    def test_that_select_calls_each
      Loquor.expects(:get).returns([{id: 8, name: "Star Wars"}])
      searcher = ApiCall::Index.new('').where(name: "star_wars")
      searcher.send(:results).expects(:select)
      searcher.select { }
    end

    def test_search_should_set_results
      expected_results = [{id: 8, name: "Star Wars"}]
      Loquor.expects(:get).returns(expected_results)

      searcher = ApiCall::Index.new('').where(name: "star_wars")
      searcher.to_a
      assert_equal expected_results, searcher.instance_variable_get("@results")
    end

    def test_search_should_create_a_results_object
      Loquor.expects(:get).returns([{id: 8, name: "Star Wars"}])
      searcher = ApiCall::Index.new('').where(name: "star_wars")
      searcher.to_a
      assert Array, searcher.instance_variable_get("@results").class
    end

    def test_find_each_calls_block_for_each_item
      searcher = ApiCall::Index.new('')
      Loquor.expects(:get).returns([{'id' => 8}, {'id' => 10}])

      ids = []
      searcher.find_each do |json|
        ids << json['id']
      end
      assert_equal [8,10], ids
    end

    def test_find_each_limits_to_200
      searcher = ApiCall::Index.new('http://foobar.com')
      Loquor.expects(:get).with("http://foobar.com?&page=1&per=200").returns([])
      searcher.find_each {}
    end

    def test_find_each_runs_multiple_times
      searcher = ApiCall::Index.new('http://foobar.com')
      results = 200.times.map{""}
      Loquor.expects(:get).with("http://foobar.com?&page=1&per=200").returns(results)
      Loquor.expects(:get).with("http://foobar.com?&page=2&per=200").returns([])
      searcher.find_each {}
    end
  end
end

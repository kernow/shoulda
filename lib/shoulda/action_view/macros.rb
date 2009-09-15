module Shoulda # :nodoc:
  module ActionView # :nodoc:
    # = Macro test helpers for your view
    #
    # By using the macro helpers you can quickly and easily create concise and
    # easy to read test suites.
    #
    # This code segment:
    #   context "on GET to :new" do
    #     setup do
    #       get :new
    #     end
    #
    #     should_render_page_with_metadata :title => /index/
    #
    #     should "do something else really cool" do
    #       assert_select '#really_cool'
    #     end
    #   end
    #
    # Would produce 3 tests for the +show+ action
    module Macros

      # Macro that creates a test asserting a form is present in the view
      # with a given action and method.
      #
      # The passed description will be used when generating the test name.
      #
      # Example:
      #
      #   should_render_a_form_to("update a user", :method => "put") { user_path(@user) }
      def should_render_a_form_to(description, options = {}, &block)
        should "render a form to #{description}" do
          expected_url  = instance_eval(&block)
          form_method   = case options[:method]
            when "post", "put", "delete" : "post"
            else "get"
            end
          assert_select "form[action=?][method=?]",
                        expected_url,
                        form_method,
                        true,
                        "The template doesn't contain a <form> element with the action #{expected_url}" do |elms|
            
            if options[:id]
              elms.each do |elm|
                assert_select elm, "##{options[:id]}", true, "The template doesn't contain a <form> element with the id #{options[:id]}"
              end
            end
            
            unless %w{get post}.include? options[:method]
              assert_select "input[name=_method][value=?]",
                            options[:method],
                            true,
                            "The template doesn't contain a <form> for #{expected_url} using the method #{options[:method]}"
            end
          end
        end
      end


      # Macro that creates a test asserting that the rendered view contains a <form> element.
      #
      # Deprecated.
      def should_render_a_form
        warn "[DEPRECATION] should_render_a_form is deprecated."
        should "display a form" do
          assert_select "form", true, "The template doesn't contain a <form> element"
        end
      end

      # Deprecated.
      #
      # Macro that creates a test asserting that the rendered view contains the selected metatags.
      # Values can be string or Regexps.
      # Example:
      #
      #   should_render_page_with_metadata :description => "Description of this page", :keywords => /post/
      #
      # You can also use this method to test the rendered views title.
      #
      # Example:
      #   should_render_page_with_metadata :title => /index/
      def should_render_page_with_metadata(options)
        warn "[DEPRECATION] should_render_page_with_metadata is deprecated."
        options.each do |key, value|
          should "have metatag #{key}" do
            if key.to_sym == :title
              assert_select "title", value
            else
              assert_select "meta[name=?][content#{"*" if value.is_a?(Regexp)}=?]", key, value
            end
          end
        end
      end
    end
  end
end


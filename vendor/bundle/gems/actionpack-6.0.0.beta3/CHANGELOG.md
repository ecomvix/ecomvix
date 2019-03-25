## Rails 6.0.0.beta3 (March 11, 2019) ##

*   No changes.


## Rails 6.0.0.beta2 (February 25, 2019) ##

*   Make debug exceptions works in an environment where ActiveStorage is not loaded.

    *Tomoyuki Kurosawa*

*   `ActionDispatch::SystemTestCase.driven_by` can now be called with a block
    to define specific browser capabilities.

    *Edouard Chin*


## Rails 6.0.0.beta1 (January 18, 2019) ##

*   Remove deprecated `fragment_cache_key` helper in favor of `combined_fragment_cache_key`.

    *Rafael Mendonça França*

*   Remove deprecated methods in `ActionDispatch::TestResponse`.

    `#success?`, `missing?` and `error?` were deprecated in Rails 5.2 in favor of
    `#successful?`, `not_found?` and `server_error?`.

    *Rafael Mendonça França*

*   Introduce ActionDispatch::HostAuthorization

    This is a new middleware that guards against DNS rebinding attacks by
    explicitly permitting the hosts a request can be made to.

    Each host is checked with the case operator (`#===`) to support `RegExp`,
    `Proc`, `IPAddr` and custom objects as host allowances.

    *Genadi Samokovarov*

*   Allow using `parsed_body` in `ActionController::TestCase`.

    In addition to `ActionDispatch::IntegrationTest`, allow using
    `parsed_body` in `ActionController::TestCase`:

    ```
    class SomeControllerTest < ActionController::TestCase
      def test_some_action
        post :action, body: { foo: 'bar' }
        assert_equal({ "foo" => "bar" }, response.parsed_body)
      end
    end
    ```

    Fixes #34676.

    *Tobias Bühlmann*

*   Raise an error on root route naming conflicts.

    Raises an ArgumentError when multiple root routes are defined in the
    same context instead of assigning nil names to subsequent roots.

    *Gannon McGibbon*

*   Allow rescue from parameter parse errors:

    ```
    rescue_from ActionDispatch::Http::Parameters::ParseError do
      head :unauthorized
    end
    ```

    *Gannon McGibbon*, *Josh Cheek*

*   Reset Capybara sessions if failed system test screenshot raising an exception.

    Reset Capybara sessions if `take_failed_screenshot` raise exception
    in system test `after_teardown`.

    *Maxim Perepelitsa*

*   Use request object for context if there's no controller

    There is no controller instance when using a redirect route or a
    mounted rack application so pass the request object as the context
    when resolving dynamic CSP sources in this scenario.

    Fixes #34200.

    *Andrew White*

*   Apply mapping to symbols returned from dynamic CSP sources

    Previously if a dynamic source returned a symbol such as :self it
    would be converted to a string implicitly, e.g:

        policy.default_src -> { :self }

    would generate the header:

        Content-Security-Policy: default-src self

    and now it generates:

        Content-Security-Policy: default-src 'self'

    *Andrew White*

*   Add `ActionController::Parameters#each_value`.

    *Lukáš Zapletal*

*   Deprecate `ActionDispatch::Http::ParameterFilter` in favor of `ActiveSupport::ParameterFilter`.

    *Yoshiyuki Kinjo*

*   Encode Content-Disposition filenames on `send_data` and `send_file`.
    Previously, `send_data 'data', filename: "\u{3042}.txt"` sends
    `"filename=\"\u{3042}.txt\""` as Content-Disposition and it can be
    garbled.
    Now it follows [RFC 2231](https://tools.ietf.org/html/rfc2231) and
    [RFC 5987](https://tools.ietf.org/html/rfc5987) and sends
    `"filename=\"%3F.txt\"; filename*=UTF-8''%E3%81%82.txt"`.
    Most browsers can find filename correctly and old browsers fallback to ASCII
    converted name.

    *Fumiaki Matsushima*

*   Expose `ActionController::Parameters#each_key` which allows iterating over
    keys without allocating an array.

    *Richard Schneeman*

*   Purpose metadata for signed/encrypted cookies.

    Rails can now thwart attacks that attempt to copy signed/encrypted value
    of a cookie and use it as the value of another cookie.

    It does so by stashing the cookie-name in the purpose field which is
    then signed/encrypted along with the cookie value. Then, on a server-side
    read, we verify the cookie-names and discard any attacked cookies.

    Enable `action_dispatch.use_cookies_with_metadata` to use this feature, which
    writes cookies with the new purpose and expiry metadata embedded.

    *Assain Jaleel*

*   Raises `ActionController::RespondToMismatchError` with conflicting `respond_to` invocations.

    `respond_to` can match multiple types and lead to undefined behavior when
    multiple invocations are made and the types do not match:

        respond_to do |outer_type|
          outer_type.js do
            respond_to do |inner_type|
              inner_type.html { render body: "HTML" }
            end
          end
        end

    *Patrick Toomey*

*   `ActionDispatch::Http::UploadedFile` now delegates `to_path` to its tempfile.

    This allows uploaded file objects to be passed directly to `File.read`
    without raising a `TypeError`:

        uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: tmp_file)
        File.read(uploaded_file)

    *Aaron Kromer*

*   Pass along arguments to underlying `get` method in `follow_redirect!`

    Now all arguments passed to `follow_redirect!` are passed to the underlying
    `get` method. This for example allows to set custom headers for the
    redirection request to the server.

        follow_redirect!(params: { foo: :bar })

    *Remo Fritzsche*

*   Introduce a new error page to when the implicit render page is accessed in the browser.

    Now instead of showing an error page that with exception and backtraces we now show only
    one informative page.

    *Vinicius Stock*

*   Introduce `ActionDispatch::DebugExceptions.register_interceptor`.

    Exception aware plugin authors can use the newly introduced
    `.register_interceptor` method to get the processed exception, instead of
    monkey patching DebugExceptions.

        ActionDispatch::DebugExceptions.register_interceptor do |request, exception|
          HypoteticalPlugin.capture_exception(request, exception)
        end

    *Genadi Samokovarov*

*   Output only one Content-Security-Policy nonce header value per request.

    Fixes #32597.

    *Andrey Novikov*, *Andrew White*

*   Move default headers configuration into their own module that can be included in controllers.

    *Kevin Deisz*

*   Add method `dig` to `session`.

    *claudiob*, *Takumi Shotoku*

*   Controller level `force_ssl` has been deprecated in favor of
    `config.force_ssl`.

    *Derek Prior*

*   Rails 6 requires Ruby 2.5.0 or newer.

    *Jeremy Daer*, *Kasper Timm Hansen*


Please check [5-2-stable](https://github.com/rails/rails/blob/5-2-stable/actionpack/CHANGELOG.md) for previous changes.

## Rails 6.0.0.beta3 (March 11, 2019) ##

*   No changes.


## Rails 6.0.0.beta2 (February 25, 2019) ##

*   Fix prepared statements caching to be enabled even when query caching is enabled.

    *Ryuta Kamizono*

*   Ensure `update_all` series cares about optimistic locking.

    *Ryuta Kamizono*

*   Don't allow `where` with non numeric string matches to 0 values.

    *Ryuta Kamizono*

*   Introduce `ActiveRecord::Relation#destroy_by` and `ActiveRecord::Relation#delete_by`.

    `destroy_by` allows relation to find all the records matching the condition and perform
    `destroy_all` on the matched records.

    Example:

        Person.destroy_by(name: 'David')
        Person.destroy_by(name: 'David', rating: 4)

        david = Person.find_by(name: 'David')
        david.posts.destroy_by(id: [1, 2, 3])

    `delete_by` allows relation to find all the records matching the condition and perform
    `delete_all` on the matched records.

    Example:

        Person.delete_by(name: 'David')
        Person.delete_by(name: 'David', rating: 4)

        david = Person.find_by(name: 'David')
        david.posts.delete_by(id: [1, 2, 3])

    *Abhay Nikam*

*   Don't allow `where` with invalid value matches to nil values.

    Fixes #33624.

    *Ryuta Kamizono*

*   SQLite3: Implement `add_foreign_key` and `remove_foreign_key`.

    *Ryuta Kamizono*

*   Deprecate using class level querying methods if the receiver scope
    regarded as leaked. Use `klass.unscoped` to avoid the leaking scope.

    *Ryuta Kamizono*

*   Allow applications to automatically switch connections.

    Adds a middleware and configuration options that can be used in your
    application to automatically switch between the writing and reading
    database connections.

    `GET` and `HEAD` requests will read from the replica unless there was
    a write in the last 2 seconds, otherwise they will read from the primary.
    Non-get requests will always write to the primary. The middleware accepts
    an argument for a Resolver class and a Operations class where you are able
    to change how the auto-switcher works to be most beneficial for your
    application.

    To use the middleware in your application you can use the following
    configuration options:

    ```
    config.active_record.database_selector = { delay: 2.seconds }
    config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
    config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session
    ```

    To change the database selection strategy, pass a custom class to the
    configuration options:

    ```
    config.active_record.database_selector = { delay: 10.seconds }
    config.active_record.database_resolver = MyResolver
    config.active_record.database_resolver_context = MyResolver::MyCookies
    ```

    *Eileen M. Uchitelle*

*   MySQL: Support `:size` option to change text and blob size.

    *Ryuta Kamizono*

*   Make `t.timestamps` with precision by default.

    *Ryuta Kamizono*


## Rails 6.0.0.beta1 (January 18, 2019) ##

*   Remove deprecated `#set_state` from the transaction object.

    *Rafael Mendonça França*

*   Remove deprecated `#supports_statement_cache?` from the database adapters.

    *Rafael Mendonça França*

*   Remove deprecated `#insert_fixtures` from the database adapters.

    *Rafael Mendonça França*

*   Remove deprecated `ActiveRecord::ConnectionAdapters::SQLite3Adapter#valid_alter_table_type?`.

    *Rafael Mendonça França*

*   Do not allow passing the column name to `sum` when a block is passed.

    *Rafael Mendonça França*

*   Do not allow passing the column name to `count` when a block is passed.

    *Rafael Mendonça França*

*   Remove delegation of missing methods in a relation to arel.

    *Rafael Mendonça França*

*   Remove delegation of missing methods in a relation to private methods of the class.

    *Rafael Mendonça França*

*   Deprecate `config.activerecord.sqlite3.represent_boolean_as_integer`.

    *Rafael Mendonça França*

*   Change `SQLite3Adapter` to always represent boolean values as integers.

    *Rafael Mendonça França*

*   Remove ability to specify a timestamp name for `#cache_key`.

    *Rafael Mendonça França*

*   Remove deprecated `ActiveRecord::Migrator.migrations_path=`.

    *Rafael Mendonça França*

*   Remove deprecated `expand_hash_conditions_for_aggregates`.

    *Rafael Mendonça França*

*   Set polymorphic type column to NULL on `dependent: :nullify` strategy.

    On polymorphic associations both the foreign key and the foreign type columns will be set to NULL.

    *Laerti Papa*

*   Allow permitted instance of `ActionController::Parameters` as argument of `ActiveRecord::Relation#exists?`.

    *Gannon McGibbon*

*   Add support for endless ranges introduces in Ruby 2.6.

    *Greg Navis*

*   Deprecate passing `migrations_paths` to `connection.assume_migrated_upto_version`.

    *Ryuta Kamizono*

*   MySQL: `ROW_FORMAT=DYNAMIC` create table option by default.

    Since MySQL 5.7.9, the `innodb_default_row_format` option defines the default row
    format for InnoDB tables. The default setting is `DYNAMIC`.
    The row format is required for indexing on `varchar(255)` with `utf8mb4` columns.

    *Ryuta Kamizono*

*   Fix join table column quoting with SQLite.

    *Gannon McGibbon*

*   Allow disabling scopes generated by `ActiveRecord.enum`.

    *Alfred Dominic*

*   Ensure that `delete_all` on collection proxy returns affected count.

    *Ryuta Kamizono*

*   Reset scope after delete on collection association to clear stale offsets of removed records.

    *Gannon McGibbon*

*   Add the ability to prevent writes to a database for the duration of a block.

    Allows the application to prevent writes to a database. This can be useful when
    you're building out multiple databases and want to make sure you're not sending
    writes when you want a read.

    If `while_preventing_writes` is called and the query is considered a write
    query the database will raise an exception regardless of whether the database
    user is able to write.

    This is not meant to be a catch-all for write queries but rather a way to enforce
    read-only queries without opening a second connection. One purpose of this is to
    catch accidental writes, not all writes.

    *Eileen M. Uchitelle*

*   Allow aliased attributes to be used in `#update_columns` and `#update`.

    *Gannon McGibbon*

*   Allow spaces in postgres table names.

    Fixes issue where "user post" is misinterpreted as "\"user\".\"post\"" when quoting table names with the postgres adapter.

    *Gannon McGibbon*

*   Cached columns_hash fields should be excluded from ResultSet#column_types

    PR #34528 addresses the inconsistent behaviour when attribute is defined for an ignored column. The following test
    was passing for SQLite and MySQL, but failed for PostgreSQL:

    ```ruby
    class DeveloperName < ActiveRecord::Type::String
      def deserialize(value)
        "Developer: #{value}"
      end
    end

    class AttributedDeveloper < ActiveRecord::Base
      self.table_name = "developers"

      attribute :name, DeveloperName.new

      self.ignored_columns += ["name"]
    end

    developer = AttributedDeveloper.create
    developer.update_column :name, "name"

    loaded_developer = AttributedDeveloper.where(id: developer.id).select("*").first
    puts loaded_developer.name # should be "Developer: name" but it's just "name"
    ```

    *Dmitry Tsepelev*

*   Make the implicit order column configurable.

    When calling ordered finder methods such as +first+ or +last+ without an
    explicit order clause, ActiveRecord sorts records by primary key. This can
    result in unpredictable and surprising behaviour when the primary key is
    not an auto-incrementing integer, for example when it's a UUID. This change
    makes it possible to override the column used for implicit ordering such
    that +first+ and +last+ will return more predictable results.

    Example:

        class Project < ActiveRecord::Base
          self.implicit_order_column = "created_at"
        end

    *Tekin Suleyman*

*   Bump minimum PostgreSQL version to 9.3.

    *Yasuo Honda*

*   Values of enum are frozen, raising an error when attempting to modify them.

    *Emmanuel Byrd*

*   Move `ActiveRecord::StatementInvalid` SQL to error property and include binds as separate error property.

    `ActiveRecord::ConnectionAdapters::AbstractAdapter#translate_exception_class` now requires `binds` to be passed as the last argument.

    `ActiveRecord::ConnectionAdapters::AbstractAdapter#translate_exception` now requires `message`, `sql`, and `binds` to be passed as keyword arguments.

    Subclasses of `ActiveRecord::StatementInvalid` must now provide `sql:` and `binds:` arguments to `super`.

    Example:

    ```
    class MySubclassedError < ActiveRecord::StatementInvalid
      def initialize(message, sql:, binds:)
        super(message, sql: sql, binds: binds)
      end
    end
    ```

    *Gannon McGibbon*

*   Add an `:if_not_exists` option to `create_table`.

    Example:

        create_table :posts, if_not_exists: true do |t|
          t.string :title
        end

    That would execute:

        CREATE TABLE IF NOT EXISTS posts (
          ...
        )

    If the table already exists, `if_not_exists: false` (the default) raises an
    exception whereas `if_not_exists: true` does nothing.

    *fatkodima*, *Stefan Kanev*

*   Defining an Enum as a Hash with blank key, or as an Array with a blank value, now raises an `ArgumentError`.

    *Christophe Maximin*

*   Adds support for multiple databases to `rails db:schema:cache:dump` and `rails db:schema:cache:clear`.

    *Gannon McGibbon*

*   `update_columns` now correctly raises `ActiveModel::MissingAttributeError`
    if the attribute does not exist.

    *Sean Griffin*

*   Add support for hash and url configs in database hash of `ActiveRecord::Base.connected_to`.

    ````
    User.connected_to(database: { writing: "postgres://foo" }) do
      User.create!(name: "Gannon")
    end

    config = { "adapter" => "sqlite3", "database" => "db/readonly.sqlite3" }
    User.connected_to(database: { reading: config }) do
      User.count
    end
    ````

    *Gannon McGibbon*

*   Support default expression for MySQL.

    MySQL 8.0.13 and higher supports default value to be a function or expression.

    https://dev.mysql.com/doc/refman/8.0/en/create-table.html

    *Ryuta Kamizono*

*   Support expression indexes for MySQL.

    MySQL 8.0.13 and higher supports functional key parts that index
    expression values rather than column or column prefix values.

    https://dev.mysql.com/doc/refman/8.0/en/create-index.html

    *Ryuta Kamizono*

*   Fix collection cache key with limit and custom select to avoid ambiguous timestamp column error.

    Fixes #33056.

    *Federico Martinez*

*   Add basic API for connection switching to support multiple databases.

    1) Adds a `connects_to` method for models to connect to multiple databases. Example:

    ```
    class AnimalsModel < ApplicationRecord
      self.abstract_class = true

      connects_to database: { writing: :animals_primary, reading: :animals_replica }
    end

    class Dog < AnimalsModel
      # connected to both the animals_primary db for writing and the animals_replica for reading
    end
    ```

    2) Adds a `connected_to` block method for switching connection roles or connecting to
    a database that the model didn't connect to. Connecting to the database in this block is
    useful when you have another defined connection, for example `slow_replica` that you don't
    want to connect to by default but need in the console, or a specific code block.

    ```
    ActiveRecord::Base.connected_to(role: :reading) do
      Dog.first # finds dog from replica connected to AnimalsBase
      Book.first # doesn't have a reading connection, will raise an error
    end
    ```

    ```
    ActiveRecord::Base.connected_to(database: :slow_replica) do
      SlowReplicaModel.first # if the db config has a slow_replica configuration this will be used to do the lookup, otherwise this will throw an exception
    end
    ```

    *Eileen M. Uchitelle*

*   Enum raises on invalid definition values

    When defining a Hash enum it can be easy to use [] instead of {}. This
    commit checks that only valid definition values are provided, those can
    be a Hash, an array of Symbols or an array of Strings. Otherwise it
    raises an ArgumentError.

    Fixes #33961

    *Alberto Almagro*

*   Reloading associations now clears the Query Cache like `Persistence#reload` does.

    ```
    class Post < ActiveRecord::Base
      has_one :category
      belongs_to :author
      has_many :comments
    end

    # Each of the following will now clear the query cache.
    post.reload_category
    post.reload_author
    post.comments.reload
    ```

    *Christophe Maximin*

*   Added `index` option for `change_table` migration helpers.
    With this change you can create indexes while adding new
    columns into the existing tables.

    Example:

        change_table(:languages) do |t|
          t.string :country_code, index: true
        end

    *Mehmet Emin İNAÇ*

*   Fix `transaction` reverting for migrations.

    Before: Commands inside a `transaction` in a reverted migration ran uninverted.
    Now: This change fixes that by reverting commands inside `transaction` block.

    *fatkodima*, *David Verhasselt*

*   Raise an error instead of scanning the filesystem root when `fixture_path` is blank.

    *Gannon McGibbon*, *Max Albrecht*

*   Allow `ActiveRecord::Base.configurations=` to be set with a symbolized hash.

    *Gannon McGibbon*

*   Don't update counter cache unless the record is actually saved.

    Fixes #31493, #33113, #33117.

    *Ryuta Kamizono*

*   Deprecate `ActiveRecord::Result#to_hash` in favor of `ActiveRecord::Result#to_a`.

    *Gannon McGibbon*, *Kevin Cheng*

*   SQLite3 adapter supports expression indexes.

    ```
    create_table :users do |t|
      t.string :email
    end

    add_index :users, 'lower(email)', name: 'index_users_on_email', unique: true
    ```

    *Gray Kemmey*

*   Allow subclasses to redefine autosave callbacks for associated records.

    Fixes #33305.

    *Andrey Subbota*

*   Bump minimum MySQL version to 5.5.8.

    *Yasuo Honda*

*   Use MySQL utf8mb4 character set by default.

    `utf8mb4` character set with 4-Byte encoding supports supplementary characters including emoji.
    The previous default 3-Byte encoding character set `utf8` is not enough to support them.

    *Yasuo Honda*

*   Fix duplicated record creation when using nested attributes with `create_with`.

    *Darwin Wu*

*   Configuration item `config.filter_parameters` could also filter out
    sensitive values of database columns when call `#inspect`.
    We also added `ActiveRecord::Base::filter_attributes`/`=` in order to
    specify sensitive attributes to specific model.

    ```
    Rails.application.config.filter_parameters += [:credit_card_number, /phone/]
    Account.last.inspect # => #<Account id: 123, name: "DHH", credit_card_number: [FILTERED], telephone_number: [FILTERED] ...>
    SecureAccount.filter_attributes += [:name]
    SecureAccount.last.inspect # => #<SecureAccount id: 42, name: [FILTERED], credit_card_number: [FILTERED] ...>
    ```

    *Zhang Kang*, *Yoshiyuki Kinjo*

*   Deprecate `column_name_length`, `table_name_length`, `columns_per_table`,
    `indexes_per_table`, `columns_per_multicolumn_index`, `sql_query_length`,
    and `joins_per_query` methods in `DatabaseLimits`.

    *Ryuta Kamizono*

*   `ActiveRecord::Base.configurations` now returns an object.

    `ActiveRecord::Base.configurations` used to return a hash, but this
    is an inflexible data model. In order to improve multiple-database
    handling in Rails, we've changed this to return an object. Some methods
    are provided to make the object behave hash-like in order to ease the
    transition process. Since most applications don't manipulate the hash
    we've decided to add backwards-compatible functionality that will throw
    a deprecation warning if used, however calling `ActiveRecord::Base.configurations`
    will use the new version internally and externally.

    For example, the following `database.yml`:

    ```
    development:
      adapter: sqlite3
      database: db/development.sqlite3
    ```

    Used to become a hash:

    ```
    { "development" => { "adapter" => "sqlite3", "database" => "db/development.sqlite3" } }
    ```

    Is now converted into the following object:

    ```
    #<ActiveRecord::DatabaseConfigurations:0x00007fd1acbdf800 @configurations=[
      #<ActiveRecord::DatabaseConfigurations::HashConfig:0x00007fd1acbded10 @env_name="development",
        @spec_name="primary", @config={"adapter"=>"sqlite3", "database"=>"db/development.sqlite3"}>
      ]
    ```

    Iterating over the database configurations has also changed. Instead of
    calling hash methods on the `configurations` hash directly, a new method `configs_for` has
    been provided that allows you to select the correct configuration. `env_name` and
    `spec_name` arguments are optional. For example, these return an array of
    database config objects for the requested environment and a single database config object
    will be returned for the requested environment and specification name respectively.

    ```
    ActiveRecord::Base.configurations.configs_for(env_name: "development")
    ActiveRecord::Base.configurations.configs_for(env_name: "development", spec_name: "primary")
    ```

    *Eileen M. Uchitelle*, *Aaron Patterson*

*   Add database configuration to disable advisory locks.

    ```
    production:
      adapter: postgresql
      advisory_locks: false
    ```

    *Guo Xiang*

*   SQLite3 adapter `alter_table` method restores foreign keys.

    *Yasuo Honda*

*   Allow `:to_table` option to `invert_remove_foreign_key`.

    Example:

       remove_foreign_key :accounts, to_table: :owners

    *Nikolay Epifanov*, *Rich Chen*

*   Add environment & load_config dependency to `bin/rake db:seed` to enable
    seed load in environments without Rails and custom DB configuration

    *Tobias Bielohlawek*

*   Fix default value for mysql time types with specified precision.

    *Nikolay Kondratyev*

*   Fix `touch` option to behave consistently with `Persistence#touch` method.

    *Ryuta Kamizono*

*   Migrations raise when duplicate column definition.

    Fixes #33024.

    *Federico Martinez*

*   Bump minimum SQLite version to 3.8

    *Yasuo Honda*

*   Fix parent record should not get saved with duplicate children records.

    Fixes #32940.

    *Santosh Wadghule*

*   Fix logic on disabling commit callbacks so they are not called unexpectedly when errors occur.

    *Brian Durand*

*   Ensure `Associations::CollectionAssociation#size` and `Associations::CollectionAssociation#empty?`
    use loaded association ids if present.

    *Graham Turner*

*   Add support to preload associations of polymorphic associations when not all the records have the requested associations.

    *Dana Sherson*

*   Add `touch_all` method to `ActiveRecord::Relation`.

    Example:

        Person.where(name: "David").touch_all(time: Time.new(2020, 5, 16, 0, 0, 0))

    *fatkodima*, *duggiefresh*

*   Add `ActiveRecord::Base.base_class?` predicate.

    *Bogdan Gusiev*

*   Add custom prefix/suffix options to `ActiveRecord::Store.store_accessor`.

    *Tan Huynh*, *Yukio Mizuta*

*   Rails 6 requires Ruby 2.5.0 or newer.

    *Jeremy Daer*, *Kasper Timm Hansen*

*   Deprecate `update_attributes`/`!` in favor of `update`/`!`.

    *Eddie Lebow*

*   Add `ActiveRecord::Base.create_or_find_by`/`!` to deal with the SELECT/INSERT race condition in
    `ActiveRecord::Base.find_or_create_by`/`!` by leaning on unique constraints in the database.

    *DHH*

*   Add `Relation#pick` as short-hand for single-value plucks.

    *DHH*


Please check [5-2-stable](https://github.com/rails/rails/blob/5-2-stable/activerecord/CHANGELOG.md) for previous changes.

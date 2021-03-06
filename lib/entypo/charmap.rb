module Entypo

  # The Charmap simply "parses" a CSS file which must conform to the following format:
  #
  # .icon$NAME$:before { content: ...} /* $codepoint$ */
  #
  class Charmap

    Icon = Struct.new(:klass, :codepoint) do
      def <=>(other)
        klass <=> other.klass
      end
    end

    # Public: Access the shared instance based on our default entypo.scss file.
    #
    # Returns Charmap instance.
    def self.instance
      @@instance ||= self.new File.expand_path('../../../app/assets/stylesheets/entypo.scss.erb', __FILE__)
    end

    # Public: Returns Array of icons.
    #
    # Returns Array of Icon instances.
    def self.icons
      instance.icons
    end

    # Access the icons array.
    attr_reader :icons

    def initialize(path)
      @icons = load(path)
    end

    private

    def load(path)
      ERB.new(File.read(path)).result.split("\n").map do |line|
        if line =~ %r{\A\.(#{Entypo.css_prefix}-[a-z0-9\-]+):before.*/\* ([0-9a-f]+)}
          Icon.new($1, $2)
        end
      end.compact.sort
    end
  end
end

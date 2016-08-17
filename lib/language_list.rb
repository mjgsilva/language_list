require 'yaml'

module LanguageList
  class LanguageInfo
    attr_reader :name, :iso_639_3, :iso_639_1, :type

    def initialize(options)
      @name = options[:name]
      @common_name = options[:common_name]
      @iso_639_3 = options[:iso_639_3]
      @iso_639_1 = options[:iso_639_1]
      @common = options[:common]
      @type = options[:type]
    end

    def common_name
      @common_name || @name
    end

    def common?
      @common
    end

    def <=>(other)
      self.name <=> other.name
    end

    def iso_639_1?
      !@iso_639_1.nil?
    end

    [:ancient, :constructed, :extinct, :historical, :living, :special].each do |type|
      define_method("#{type.to_s}?") do
        @type == type
      end
    end

    def to_s
      "#{@name}"
    end

    def self.find_by_iso_639_1(code)
      LanguageList::BY_ISO_639_1[code]
    end

    def self.find_by_iso_639_3(code)
      LanguageList::BY_ISO_639_3[code]
    end

    def self.find_by_name(name)
      LanguageList::BY_NAME[name.downcase]
    end

    def self.find(code)
      code.downcase!
      find_by_iso_639_1(code) || find_by_iso_639_3(code) || find_by_name(code)
    end
  end

  ALL_LANGUAGES = begin
    yaml_data = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__),'..', 'data', 'languages.yml')))
    yaml_data.map{ |lang| LanguageInfo.new(lang) }
  end

  ISO_639_1 = ALL_LANGUAGES.select(&:iso_639_1?)
  LIVING_LANGUAGES = ALL_LANGUAGES.select(&:living?)
  COMMON_LANGUAGES = ALL_LANGUAGES.select(&:common?)

  BY_NAME      = {}
  BY_ISO_639_1 = {}
  BY_ISO_639_3 = {}
  ALL_LANGUAGES.each do |lang|
    BY_NAME[lang.name.downcase] = lang
    BY_ISO_639_1[lang.iso_639_1] = lang if lang.iso_639_1
    BY_ISO_639_3[lang.iso_639_3] = lang if lang.iso_639_3
  end

end

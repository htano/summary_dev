# coding: utf-8
require 'uri'
require 'singleton'

class ContentsExtractor::ExtractorFactory
  include Singleton
  CONFIG_FILE = Rails.root.to_s + 
    '/lib/contents-extractor/config/domain-extractor.tsv'

  def initialize
    @config = Hash.new
    read_config_file(CONFIG_FILE)
  end

  def read_config_file(filename)
    open(filename) do |file|
      file.each do |line|
        line.chomp!
        domain, ex_type, xpath = line.split("\t")
        @config[domain] = {
          :extractor_type => ex_type,
          :xpath => xpath
        }
      end
    end
  end

  def new_extractor(url = nil)
    case get_extractor_type(url)
    when 'default'
      return ContentsExtractor::MonoExtractor.new
    when 'xpath'
      xpath = get_xpath(url)
      return ContentsExtractor::XpathExtractor.new(xpath)
    else
      return ContentsExtractor::MonoExtractor.new
    end
  end

  def get_xpath(url)
    domain = get_domain(url)
    if @config[domain]
      return @config[domain][:xpath]
    else
      return nil
    end
  end

  def get_extractor_type(url)
    domain = get_domain(url)
    if @config[domain]
      return @config[domain][:extractor_type]
    else
      return 'default'
    end
  end

  def get_domain(url)
    if url
      uri = URI(url)
      domain = uri.host
      return domain
    else
      return nil
    end
  end
end

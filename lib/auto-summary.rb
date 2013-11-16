module AutoSummary
  PARAMS_DIR = Rails.root.to_s + "/lib/auto-summary/params"
  DF_DIR = Rails.root.to_s + "/lib/text-analyzer/df_dict"
  WEIGHT_FILE = '/feature_weight.txt'
  CENTER_FILE = '/feature_center.txt'
  SCALE_FILE  = '/feature_scale.txt'
  TITLE_DF_FILE = '/title-df.txt'
  BODY_DF_FILE  = '/body-df.txt'
  AUTO_SUMMARIZER_NAME = 'system001'
  require 'auto-summary/feature-extractor'
  require 'auto-summary/summarizer'
  require 'auto-summary/trainer'
end

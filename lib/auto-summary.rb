module AutoSummary
  WEIGHT_FILE = '/feature_weight.txt'
  CENTER_FILE = '/feature_center.txt'
  SCALE_FILE  = '/feature_scale.txt'
  TITLE_DF_FILE = '/title_df.txt'
  BODY_DF_FILE  = '/body_df.txt'
  require 'auto-summary/feature-extractor'
  require 'auto-summary/summarizer'
  require 'auto-summary/trainer'
end

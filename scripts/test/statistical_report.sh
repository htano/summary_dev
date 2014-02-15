#!/bin/bash
cd /var/apps/summary_dev
RAILS_ENV=production /usr/local/rbenv/shims/rails runner Message.inform_user_number.deliver

# = Informations
#
# == License
#
# Ekylibre - Simple agricultural ERP
# Copyright (C) 2008-2009 Brice Texier, Thibaud Merigon
# Copyright (C) 2010-2012 Brice Texier
# Copyright (C) 2012-2016 Brice Texier, David Joulin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see http://www.gnu.org/licenses.
#
# == Table: map_backgrounds
#
#  base_layer   :string
#  base_variant :string
#  by_default   :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  creator_id   :integer
#  enabled      :boolean          default(FALSE), not null
#  id           :integer          not null, primary key
#  lock_version :integer          default(0), not null
#  name         :string           not null
#  updated_at   :datetime         not null
#  updater_id   :integer
#  url          :string           not null
#
class MapBackground < Ekylibre::Record::Base
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_inclusion_of :by_default, :enabled, in: [true, false]
  validates_presence_of :name, :url
  # ]VALIDATORS]
  validates_format_of :url, :with => URI::regexp(%w(http https))
  scope :availables, -> { where(enabled: true).order(by_default: :desc) }
  scope :by_default, -> { availables.first }

  def self.load_defaults

    MapBackgrounds::Layer.items.each do |item|
      attrs = {
        enabled: item.enabled,
        name: item.label,
        by_default: item.by_default,
        url: item.url
      }
      MapBackground.where(base_layer: item.provider_name, base_variant: item.name).first_or_create(attrs)
    end

  end

  def to_json_object
    JSON.parse(to_json).merge(options: MapBackgrounds::Layer.find(base_layer, base_variant).options).jsonize_keys
  end
end

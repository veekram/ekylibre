# = Informations
#
# == License
#
# Ekylibre - Simple ERP
# Copyright (C) 2009-2013 Brice Texier, Thibaud Merigon
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses.
#
# == Table: product_natures
#
#  active                    :boolean          not null
#  asset_account_id          :integer
#  category_id               :integer          not null
#  charge_account_id         :integer
#  commercial_description    :text
#  commercial_name           :string(255)      not null
#  contour                   :string(255)
#  created_at                :datetime         not null
#  creator_id                :integer
#  depreciable               :boolean          not null
#  derivative_of             :string(127)
#  description               :text
#  id                        :integer          not null, primary key
#  individual                :boolean          not null
#  individual_unit_name      :string(255)
#  lock_version              :integer          default(0), not null
#  name                      :string(255)      not null
#  net_volume                :decimal(19, 4)
#  net_weight                :decimal(19, 4)
#  number                    :string(31)       not null
#  product_account_id        :integer
#  purchasable               :boolean          not null
#  purchase_unit             :string(255)
#  purchase_unit_coefficient :decimal(19, 4)
#  purchase_unit_modulo      :decimal(19, 4)
#  purchase_unit_name        :string(255)
#  reductible                :boolean          not null
#  sale_unit                 :string(255)
#  sale_unit_coefficient     :decimal(19, 4)
#  sale_unit_modulo          :decimal(19, 4)
#  sale_unit_name            :string(255)
#  saleable                  :boolean          not null
#  stock_account_id          :integer
#  storable                  :boolean          not null
#  subscribing               :boolean          not null
#  subscription_duration     :string(255)
#  subscription_nature_id    :integer
#  unit                      :string(255)      not null
#  updated_at                :datetime         not null
#  updater_id                :integer
#  variety                   :string(127)      not null
#


class ProductNature < Ekylibre::Record::Base
  # attr_accessible :active, :commercial_description, :commercial_name, :category_id, :deliverable, :description, :for_immobilizations, :for_productions, :for_purchases, :for_sales, :asset_account_id, :name, :nature, :number, :charge_account_id, :reduction_submissive, :product_account_id, :stockable, :subscription_nature_id, :subscription_period, :subscription_quantity, :trackable, :unit, :unquantifiable, :weight
  attr_accessible :purchase_unit, :purchase_unit_name, :purchase_unit_modulo, :purchase_unit_coefficient, :active, :commercial_description, :commercial_name, :category_id, :derivative_of, :description, :depreciable, :purchasable, :saleable, :asset_account_id, :name, :number, :stock_account_id, :charge_account_id, :product_account_id, :storable, :subscription_nature_id, :subscription_duration, :unit, :reductible, :individual, :subscribing, :variety
  #enumerize :nature, :in => [:product, :service, :subscription], :default => :product, :predicates => true
  enumerize :variety, :in => Nomen::Varieties.all, :predicates => {:prefix => true}
  belongs_to :asset_account, :class_name => "Account"
  belongs_to :charge_account, :class_name => "Account"
  belongs_to :product_account, :class_name => "Account"
  belongs_to :stock_account, :class_name => "Account"
  belongs_to :subscription_nature
  belongs_to :category, :class_name => "ProductNatureCategory"
  # TODO: enumerize :unit, :in => ??
  # belongs_to :unit
  # belongs_to :variety, :class_name => "ProductVariety"
  # has_many :available_stocks, :class_name => "ProductStock", :conditions => ["quantity > 0"], :foreign_key => :product_id
  # has_many :components, :class_name => "ProductNatureComponent", :conditions => {:active => true}, :foreign_key => :product_nature_id
  #has_many :outgoing_delivery_items, :foreign_key => :product_id
  has_many :prices, :foreign_key => :product_nature_id, :class_name => "ProductPriceTemplate"
  has_many :repartitions, :class_name => "ActivityRepartition", :foreign_key => :product_nature_id
  #has_many :purchase_items, :foreign_key => :product_id
  #has_many :reservoirs, :conditions => {:reservoir => true}, :foreign_key => :product_id
  #has_many :sale_items, :foreign_key => :product_id
  #has_many :stock_moves, :foreign_key => :product_id
  #has_many :stock_transfers, :foreign_key => :product_id
  # has_many :stocks, :foreign_key => :product_id
  has_many :subscriptions, :foreign_key => :product_nature_id
  #has_many :trackings, :foreign_key => :product_id
  has_many :products, :foreign_key => :nature_id
  has_many :indicators, :class_name => "ProductNatureIndicator"
  # has_many :buildings, :through => :stocks
  #has_one :default_stock, :class_name => "ProductStock", :order => :name, :foreign_key => :product_id
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :net_volume, :net_weight, :purchase_unit_coefficient, :purchase_unit_modulo, :sale_unit_coefficient, :sale_unit_modulo, :allow_nil => true
  validates_length_of :number, :allow_nil => true, :maximum => 31
  validates_length_of :derivative_of, :variety, :allow_nil => true, :maximum => 127
  validates_length_of :commercial_name, :contour, :individual_unit_name, :name, :purchase_unit, :purchase_unit_name, :sale_unit, :sale_unit_name, :subscription_duration, :unit, :allow_nil => true, :maximum => 255
  validates_inclusion_of :active, :depreciable, :individual, :purchasable, :reductible, :saleable, :storable, :subscribing, :in => [true, false]
  validates_presence_of :category, :commercial_name, :name, :number, :unit, :variety
  #]VALIDATORS]
  validates_presence_of :subscription_nature,   :if => :subscribing?
  validates_presence_of :subscription_period,   :if => Proc.new{|u| u.subscribing? and u.subscription_nature and u.subscription_nature.period? }
  validates_presence_of :subscription_quantity, :if => Proc.new{|u| u.subscribing? and u.subscription_nature and u.subscription_nature.quantity? }
  validates_presence_of :product_account, :if => :saleable?
  validates_presence_of :charge_account,  :if => :purchasable?
  validates_presence_of :stock_account,   :if => :storable?
  validates_presence_of :asset_account,   :if => :depreciable?
  validates_uniqueness_of :number
  validates_uniqueness_of :name

  # accepts_nested_attributes_for :stocks, :reject_if => :all_blank, :allow_destroy => true
  #acts_as_numbered

  default_scope -> { order(:name) }
  scope :availables, -> { where(:active => true).order(:name) }
  scope :stockables, -> { where(:storable => true).order(:name) }
  scope :purchaseables, -> { where(:purchasable => true).order(:name) }
  scope :producibles, -> { where(:individual => true, :variety => ["bos","animal","plant"]).order(:name) }
  scope :animals, -> { where(:individual => true, :variety => "bos").order(:name) }
  scope :plants, -> { where(:individual => true, :variety => "plant").order(:name) }
  scope :plant_medicines, -> { where(:individual => false, :variety => "plant_medicine").order(:name) }
  scope :animal_medicines, -> { where(:individual => false, :variety => "animal_medicine").order(:name) }
  scope :equipments, -> { where(:variety => "equipment").order(:name) }
  scope :buildings, -> { where(:variety => "building").order(:name) }
  scope :organic_matters, -> { where(:variety => "organic_matter").order(:name) }
  scope :mineral_matters, -> { where(:variety => "mineral_matter").order(:name) }
  scope :matters, -> { where(:subscribing => false).order(:name) }

  before_validation do
    if self.derivative_of
      self.variety ||= self.derivative_of
    end
    self.derivative_of = nil if self.variety.to_s == self.derivative_of.to_s
    # self.number = self.name.codeize.upper if !self.name.blank? and self.number.blank?
    # self.number = self.number[0..7] unless self.number.blank?
    # if self.number.blank?
      # last = self.class.reorder('number DESC').first
      # self.number = last.nil? ? 1 : last.number+1
    # end
    # while self.class.where("number=? AND id!=?", self.number, self.id||0).first
      # self.number.succ!
    # end
    self.storable = false unless self.deliverable?
    # self.traceable = false unless self.storable?
    # self.stockable = true if self.trackable?
    # self.deliverable = true if self.stockable?
    # self.producible = true
    self.commercial_name = self.name if self.commercial_name.blank?
    self.subscription_nature_id = nil unless self.subscribing?
    return true
  end

  # Returns the closest matching model based on the given variety
  def self.matching_model(variety)
    if item = Nomen::Varieties.find(variety)
      for ancestor in item.self_and_parents
        if model = ancestor.name.camelcase.constantize rescue nil
          return model if model <= Product
        end
      end
    end
    return nil
  end

  # Returns the matching model for the record
  def matching_model
    return self.class.matching_model(self.variety)
  end


  def to
    to = []
    to << :sales if self.saleable?
    to << :purchases if self.purchasable?
    # to << :produce if self.producible?
    to.collect{|x| tc('to.'+x.to_s)}.to_sentence
  end



  def deliverable?
    self.storable?
  end

  # # Returns the default
  # def default_price(options)
  #   price = nil
  #   if template = self.templates.where(:listing_id => listing_id, :active => true, :by_default => true).first
  #     price = template.price
  #   end
  #   return price
  # end

  def label
    tc('label', :product_nature => self["name"], :unit => self.unit["label"])
  end

  def informations
    tc('informations.without_components', :product_nature => self.name, :unit => self.unit.label, :size => self.components.size)
  end

  def duration
    #raise Exception.new self.subscription_nature.nature.inspect+" blabla"
    if self.subscription_nature
      self.send('subscription_'+self.subscription_nature.nature)
    else
      return nil
    end

  end

  def duration=(value)
    #raise Exception.new subscription.inspect+self.subscription_nature_id.inspect
    if self.subscription_nature
      self.send('subscription_'+self.subscription_nature.nature+'=', value)
    end
  end

  def default_start
    # self.subscription_nature.nature == "period" ? Date.today.beginning_of_year : self.subscription_nature.actual_number
    self.subscription_nature.nature == "period" ? Date.today : self.subscription_nature.actual_number
  end

  def default_finish
    period = self.subscription_period || '1 year'
    # self.subscription_nature.nature == "period" ? Date.today.next_year.beginning_of_year.next_month.end_of_month : (self.subscription_nature.actual_number + ((self.subscription_quantity-1)||0))
    self.subscription_nature.nature == "period" ? Delay.compute(period+", 1 day ago", Date.today) : (self.subscription_nature.actual_number + ((self.subscription_quantity-1)||0))
  end

  def default_subscription_label_for(entity)
    return nil unless self.nature == "subscrip"
    entity  = nil unless entity.is_a? Entity
    address = entity.default_contact.address rescue nil
    entity = entity.full_name rescue "???"
    if self.subscription_nature.nature == "period"
      return tc('subscription_label.period', :start => ::I18n.localize(Date.today), :finish => ::I18n.localize(Delay.compute(self.subscription_period.blank? ? '1 year, 1 day ago' : self.product.subscription_period)), :entity => entity, :address => address, :subscription_nature => self.subscription_nature.name)
    elsif self.subscription_nature.nature == "quantity"
      return tc('subscription_label.quantity', :start => self.subscription_nature.actual_number.to_i, :finish => (self.subscription_nature.actual_number.to_i + ((self.subscription_quantity-1)||0)), :entity => entity, :address => address, :subscription_nature => self.subscription_nature.name)
    end
  end

  # TODO : move stock methods in operation / product
  # Create real stocks moves to update the real state of stocks
  #def move_outgoing_stock(options={})
  #  add_stock_move(options.merge(:virtual => false, :incoming => false))
  #end

 # def move_incoming_stock(options={})
  #  add_stock_move(options.merge(:virtual => false, :incoming => true))
 # end

  # Create virtual stock moves to reserve the products
 # def reserve_outgoing_stock(options={})
  #  add_stock_move(options.merge(:virtual => true, :incoming => false))
  #end

  #def reserve_incoming_stock(options={})
  #  add_stock_move(options.merge(:virtual => true, :incoming => true))
  #end

  # Create real stocks moves to update the real state of stocks
  #def move_stock(options={})
   # add_stock_move(options.merge(:virtual => false))
  #end

  # Create virtual stock moves to reserve the products
  #def reserve_stock(options={})
  #  add_stock_move(options.merge(:virtual => true))
  #end

  # Generic method to add stock move in product's stock
  #def add_stock_move(options={})
  # return true unless self.stockable?
  #  incoming = options.delete(:incoming)
  #  attributes = options.merge(:generated => true)
  #  origin = options[:origin]
  #  if origin.is_a? ActiveRecord::Base
  #    code = [:number, :code, :name, :id].detect{|x| origin.respond_to? x}
  #    attributes[:name] = tc('stock_move', :origin => (origin ? ::I18n.t("activerecord.models.#{origin.class.name.underscore}") : "*"), :code => (origin ? origin.send(code) : "*"))
  #    for attribute in [:quantity, :unit, :tracking_id, :building_id, :product_id]
  #      unless attributes.keys.include? attribute
  #        attributes[attribute] ||= origin.send(attribute) rescue nil
  #      end
  #    end
  #  end
  #  attributes[:quantity] = -attributes[:quantity] unless incoming
  #  attributes[:building_id] ||= self.stocks.first.building_id if self.stocks.size > 0
  #  attributes[:planned_on] ||= Date.today
  #  attributes[:moved_on] ||= attributes[:planned_on] unless attributes.keys.include? :moved_on
  #  self.stock_moves.create!(attributes)
  # end


end

class Seed

  def self.create(factory_name, overrides = nil)
    FactoryGirl::SeedGenerator.create(factory_name, overrides)
  end
end

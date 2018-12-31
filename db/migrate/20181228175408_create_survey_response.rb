class CreateSurveyResponse < ActiveRecord::Migration[5.0]
  def change
    create_table :survey_responses do |t|
      t.uuid :uuid, null: false
      t.integer :user_id, null: false
      t.integer :survey_id, null: false
      t.integer :organization_id, null: false
      t.jsonb :response, null: false, default: '{}'
      t.timestamps
    end

    add_index :survey_responses, :response, using: :gin
    add_index :survey_responses, [:user_id, :survey_id, :organization_id], name: 'sr_index', unique: true

    create_table :surveys do |t|
      t.uuid :uuid
      t.integer :organization_id
      t.timestamps
    end

    add_index :surveys, :organization_id

    create_table :questions do |t|
      t.uuid :uuid
      t.string :slug, null: false
      t.string :description
      t.text :question_text, null: false
      t.string :question_type, null: false
      t.text :question_subtext
      t.text :question_choices, array: true, default: []
      t.boolean :queryable, default: false
      t.integer :survey_id, null: false
      t.integer :index
      t.timestamps
    end

    add_index :questions, :index, unique: true
    add_index :questions, :survey_id, unique: true

    add_column :organizations, :published_at, :datetime
  end
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Rails.env.development?
  foster_dogs_org = Organization.where(
    uuid: Organization::FOSTER_DOGS_UUID,
    slug: 'foster-dogs',
    name: 'Foster Dogs NYC'
  ).first_or_create!
  foster_dogs_org.survey ||= foster_dogs_org.create_survey
  if foster_dogs_org.survey.questions.any?
    puts "Foster Dogs org already has #{foster_dogs_org.survey.questions.count} questions, skipping question setup"
  else
    foster_dogs_org.survey.questions.create(
      slug: 'fostered-before',
      question_text: 'Have you fostered before?',
      question_type: Question::BOOLEAN,
      queryable: true,
      required: true,
      displayable: true
    )
    foster_dogs_org.survey.questions.create(
      slug: 'previous-foster-orgs',
      question_text: 'If so, which organizations have you previously fostered with?',
      question_type: Question::MULTI_SELECT,
      question_choices: ['ACC', 'Animal Lighthouse', 'Badass Brooklyn', 'BARRK LI', 'Friends with Four Paws', 'Hearts and Bones', 'In Our Hands', 'Louie\'s Legacy', 'Muddy Paws', 'PupStarz', 'Sean Casey', 'Shelter Chic', 'Social Tees', 'Sochi Dogs', 'Sugar Mutts', 'Twenty Paws', 'Korean K9 Rescue', 'Mr. Bones & Co', 'Other'],
      queryable: true,
      required: false,
      displayable: true
    )
    foster_dogs_org.survey.questions.create(
      slug: 'fospice',
      question_text: 'Are you interested in participating in our Fospice program?',
      question_subtext: "If you are interested in being a 'Forever Foster' caretaker for our 'Fospice' program for dogs in their end-of-life months, check the box below. Learn more about the program <a target='_blank' href='http://fosterdogsnyc.com/fospice/'>here</a>".html_safe,
      question_type: Question::BOOLEAN,
      queryable: true,
      required: true,
      displayable: true
    )
    foster_dogs_org.survey.questions.create(
      slug: 'household-cats',
      question_text: 'How many cats are in your household?',
      question_type: Question::COUNT,
      queryable: true,
      required: true,
      displayable: true
    )
    foster_dogs_org.survey.questions.create(
      slug: 'household-dogs',
      question_text: 'How many dogs are in your household?',
      question_type: Question::COUNT,
      queryable: true,
      required: true,
      displayable: true
    )
    foster_dogs_org.survey.questions.create(
      slug: 'household-other-pets',
      question_text: 'Do you own other pets?',
      question_type: Question::BOOLEAN,
      queryable: true,
      required: true,
      displayable: true
    )
    foster_dogs_org.survey.questions.create(
      slug: 'dog-size',
      question_text: 'What size of dog are you open to fostering?',
      question_type: Question::MULTI_SELECT,
      question_choices: ['Small (Up to 25 lbs.)', 'Medium (25-50 lbs.)', 'Large (50 lbs and up)'],
      queryable: true,
      required: true,
      displayable: true
    )
    foster_dogs_org.survey.questions.create(
      slug: 'experience',
      question_text: 'What experience do you have with dogs?',
      question_type: Question::MULTI_SELECT,
      question_choices: ['Dogsat', 'Fostered', 'Own / Owned a dog', 'Volunteered', 'Other'],
      queryable: true,
      required: true,
      displayable: true
    )
    foster_dogs_org.survey.questions.create(
      slug: 'home-alone',
      question_text: 'How often are you out of the house?',
      question_subtext: "On average, how long would the dog be alone during the workweek? Note: If you are away for more than 8 hours a day you should consider hiring a dog walker or have someone check in on the dog. Some rescue organizations offer discounted dog walks.",
      question_type: Question::MULTI_SELECT,
      question_choices: ['Almost never (0-3 hrs/day)', '4-7 hours per day', '8+ hours per day'],
      queryable: true,
      required: true,
      displayable: true
    )
    foster_dogs_org.survey.questions.create(
      slug: 'activity',
      question_text: 'How active do you prefer your foster to be?',
      question_type: Question::MULTI_SELECT,
      question_choices: ['Low activity', 'Moderately active', 'Active', 'Young puppy'],
      queryable: true,
      required: true,
      displayable: true
    )
    foster_dogs_org.survey.questions.create(
      slug: 'big-dogs',
      question_text: 'Are you interested in fostering big dogs?',
      question_type: Question::BOOLEAN,
      queryable: true,
      required: true,
      displayable: true
    )
    foster_dogs_org.survey.questions.create(
      slug: 'cats',
      question_text: 'Are you interested in fostering cats?',
      question_type: Question::BOOLEAN,
      queryable: true,
      required: true,
      displayable: true
    )
  end

  admin_user = User.where(email: 'admin@example.com').first_or_create! do |user|
    user.name = "Admin User"
    user.email = "admin@example.com"
    user.password = "admintest"
    user.accepted_terms_at = Time.zone.now
    user.first_name = "Admin"
    user.last_name = "User"
  end
  admin_user.add_role(:admin, foster_dogs_org)
end

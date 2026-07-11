require "test_helper"

class InspectionTest < ActiveSupport::TestCase
  test "is invalid without required fields" do
    inspection = Inspection.new

    assert_not inspection.valid?
    assert_not_empty inspection.errors[:contract]
    assert_not_empty inspection.errors[:property]
    assert_not_empty inspection.errors[:inspection_type]
    assert_not_empty inspection.errors[:inspection_date]
    assert_not_empty inspection.errors[:entry_type]
  end

  test "returns only checklist items marked as selected" do
    inspection = Inspection.new(
      checklist: {
        "portas_e_janelas" => { "label" => "Portas e janelas", "value" => true, "status" => "ok", "observation" => nil },
        "paredes_e_teto" => { "label" => "Paredes e teto", "value" => false, "status" => "ok", "observation" => nil }
      }
    )

    assert_equal ["portas_e_janelas"], inspection.selected_checklist_items.keys
  end

  test "persists a checklist built from indifferent access hashes" do
    inspection = Inspection.new(
      contract: contracts(:one),
      property: properties(:one),
      inspection_type: :entry,
      inspection_date: Date.current,
      entry_type: :standard,
      status: :draft,
      checklist: ActiveSupport::HashWithIndifferentAccess.new(
        "portas_e_janelas" => ActiveSupport::HashWithIndifferentAccess.new(
          "label" => "Portas e janelas",
          "value" => true,
          "status" => "defect",
          "observation" => "Vidros quebrados"
        )
      )
    )

    assert inspection.save
  end

  test "maps action buttons to inspection status" do
    assert_equal :completed, Inspection.status_for_action("completed")
    assert_equal :with_reservations, Inspection.status_for_action("with_reservations")
    assert_equal :cancelled, Inspection.status_for_action("cancelled")
  end
end

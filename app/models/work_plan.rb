class WorkPlan < ActiveRecord::Base
  resourcify
  
  belongs_to :clinic_doctor
  
  attr_accessible :day, :start, :end, :clinic_doctor_id
  
  validates :clinic_doctor, :presence => true
  validate :start_end
  validate :bilocation

  private
    def start_end
      errors.add(:start, "sholudn't be greater or equal than #{:end}") if self.start >= self.end
    end
    
    def bilocation
      errors.add(:doctor, "can't bilocate") if WorkPlan.joins(:clinic_doctor).where('doctor_id = ?', self.clinic_doctor.doctor_id).where('day = ?', self.day).where('work_plans.id != ?', self.id).where('(? BETWEEN start AND end) OR (? BETWEEN start AND end)', self.start, self.end).exists?
    end
end

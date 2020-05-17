#

9236  find . -type d -exec rename 's/\s+/_/g' {} +
9237  find . -type d -exec rename 's/\"/'in'/g' {} +
9238  find . -type d -exec rename 's/\(|\)/''/g' {} +
9239  find . -type f -exec rename 's/\s+/_/g' {} +
9240  find . -type f -exec rename 's/\(|\)/''/g' {} +
9241  find . -type f -exec rename 's/\"/'in'/g' {} +
9242  find . -type d -exec rename 's/\s+/_/g' {} +
9243  find . -type d -exec rename 's/\:/_/g' {} +

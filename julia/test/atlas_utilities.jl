@testset "ATLAS Getters" begin

depression_concept_id = 440383
depression_concept = get_atlas_concept(depression_concept_id)
@test_reference "refs/get_atlas_concept.txt" get_atlas_concept(depression_concept_id)
@test_reference "refs/get_atlas_concept_set.txt" get_atlas_concept_set(depression_concept)

end

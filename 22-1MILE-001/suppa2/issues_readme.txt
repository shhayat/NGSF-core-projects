Following error is generated when I ran 02_Sailfish_index.sh

rocessed 2547000000 positionssailfish: /sailfish/external/install/include/sparsehash/internal/densehashtable.h:782: void google::dense_hashtable<Value, Key, HashFcn, ExtractKey, SetKey, EqualKey, Alloc>::clear_to_size(google::dense_hashtable<Value, Key, HashFcn, ExtractKey, SetKey, EqualKey, Alloc>::size_type) [with Value = std::pair<const long unsigned int, rapmap::utils::SAInterval<long int> >; Key = long unsigned int; HashFcn = rapmap::utils::KmerKeyHasher; ExtractKey = google::dense_hash_map<long unsigned int, rapmap::utils::SAInterval<long int>, rapmap::utils::KmerKeyHasher, std::equal_to<long unsigned int>, google::libc_allocator_with_realloc<std::pair<const long unsigned int, rapmap::utils::SAInterval<long int> > > >::SelectKey; SetKey = google::dense_hash_map<long unsigned int, rapmap::utils::SAInterval<long int>, rapmap::utils::KmerKeyHasher, std::equal_to<long unsigned int>, google::libc_allocator_with_realloc<std::pair<const long unsigned int, rapmap::utils::SAInterval<long int> > > >::SetKey; EqualKey = std::equal_to<long unsigned int>; Alloc = google::libc_allocator_with_realloc<std::pair<const long unsigned int, rapmap::utils::SAInterval<long int> > >; google::dense_hashtable<Value, Key, HashFcn, ExtractKey, SetKey, EqualKey, Alloc>::size_type = long unsigned int]: Assertion `table' failed.
/var/spool/slurm/job936830/slurm_script: line 17: 258614 Aborted                 (core dumped) ${sailfish}/sailfish index -t ${ref} -o ${OUTDIR} -p ${NCPU}

Tried to solve it by changing memory size but it didn't work out.

Next 

Tried salmon quantification and it worked and generated TPM values.

Next at step 4 04_psi_calculation.sh when files from 03_salmon_quantification.sh are passed it generated following error
ERROR:lib.tools:I/O Error: No such file or directory
ERROR:psiCalculator:Unknown error: 1

Tried searching for the solution but didn't find any valid solution.

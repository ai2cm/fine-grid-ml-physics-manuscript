run_all:
	jupyter nbconvert --to notebook --inplace --execute figure_1_and_2.ipynb
	jupyter nbconvert --to notebook --inplace --execute figure_3_and_4.ipynb
	jupyter nbconvert --to notebook --inplace --execute figure_5.ipynb
	jupyter nbconvert --to notebook --inplace --execute figure_6_and_7.ipynb
	jupyter nbconvert --to notebook --inplace --execute figure_8_9_10.ipynb
	jupyter nbconvert --to notebook --inplace --execute figure_11.ipynb
	jupyter nbconvert --to notebook --inplace --execute figure_12.ipynb
	jupyter nbconvert --to notebook --inplace --execute misc-compare-initialization-times.ipynb
	jupyter nbconvert --to notebook --inplace --execute misc-compare-SSTs.ipynb
	jupyter nbconvert --to notebook --inplace --execute table_1.ipynb

run_%:
	jupyter nbconvert --to notebook --inplace --execute $*.ipynb

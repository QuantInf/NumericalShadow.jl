using ArgParse
using HDF5
using NumericalShadow

function get_sampling_f_from_name(sfn::String)
  if sfn=="random_ket_complex" return NumericalShadow.random_ket_complex end
  if sfn=="random_ket_real" return NumericalShadow.random_ket_real end
  if sfn=="random_ket_complex_entangled" return NumericalShadow.random_ket_complex_entangled end
  if sfn=="random_ket_real_entangled" return NumericalShadow.random_ket_real_entangled end
  if sfn=="random_ket_real_separable" return NumericalShadow.random_ket_real_separable end
  if sfn=="random_ket_complex_separable" return NumericalShadow.random_ket_complex_separable end
  return error("No such function")
end


function parse_commandline()
    s = ArgParse.ArgParseSettings()

    ArgParse.@add_arg_table s begin
        "--source_file_name", "-s"
            arg_type = String
            help = "CSV file to read"
        "--directory", "-d"
            arg_type = String
            help = "Source / target directory"
        "--lines", "-l"
            arg_type = String
            help = "Lines to execute in julia Array format. Example: [2 3 4]. Or all lines: 'all'."
    end

    return ArgParse.parse_args(s)
end

function main()
    parsed_args = parse_commandline()
#     println("Parsed args:")
#     for pa in parsed_args
#        println("  $(pa[1])  =>  $(pa[2])")
#     end

    lines=[]
    directory=""
    source_file_name=""
    for pa in parsed_args
       if pa[1]=="directory" 
          directory=pa[2]
       end
       if pa[1]=="source_file_name" 
          source_file_name=pa[2]
       end
       if pa[1]=="lines" 
	  if pa[2]=="all"
             lines=[]
          else
             lines=eval(parse(pa[2]))
          end
       end
    end
    
    csv=readcsv(joinpath(directory,source_file_name))
    
    if length(lines)==0
      lines=[2:size(csv)[1]]
    end
    
    for l in lines
      matrix_id=csv[l,1]
      M=complex128(eval(parse(csv[l,2])))
      function_name=csv[l,3]
      samples=int(csv[l,4])
      xdensity=int(csv[l,5])
      ydensity=int(csv[l,6])

      bounding_box=NumericalShadow.get_bounding_box(M)
      matrix_latex=repr(M)
      tic()
      histogram=NumericalShadow.numerical_shadow_parallel(
		M,get_sampling_f_from_name(function_name),
		samples, xdensity, ydensity
		)
      
      output_filename="histrogram-"*matrix_id*"-"*function_name*"-"*string(samples)*".hd5"
      
      println("Saving: "*output_filename)
      println("Calculation took: "*string(toc())*" seconds.")
      println("I used: "*string(nprocs())*" procesors.")

      fid = HDF5.h5open(joinpath(directory, output_filename), "w")

      fid["source"]="julia"
      fid["version"]="0.1"
      fid["matrix_re"] = real(M)
      fid["matrix_im"] = imag(M)
      fid["random_state_function"] = function_name
      fid["samples"] = samples
      fid["xdensity"] = xdensity
      fid["ydensity"] = ydensity
      fid["bounding_box"] = bounding_box
      fid["matrix_latex"] = matrix_latex
      fid["matrix_id"] = matrix_id
      fid["histogram"] = histogram
      HDF5.close(fid)
    end
end

main()

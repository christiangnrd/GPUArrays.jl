# GPUArrays development often happens in lockstep with other packages, so try to match branches
if haskey(ENV, "GITLAB_CI")
    using Pkg

    function match_package(package, branch)
            try
            Pkg.add(PackageSpec(name=package, rev=String(branch)))
            @info "Installed $package from $branch branch"
        catch ex
            @warn "Could not install $package from $branch branch, trying master" exception=ex
            Pkg.add(PackageSpec(name=package, rev="master"))
            @info "Installed $package from master branch"
        end
    end

    branch = ENV["CI_COMMIT_REF_NAME"]
    for package in ("Adapt", "CuArrays")
        match_package(package, branch)
    end
end

using GPUArrays, Test

@testset "JLArray" begin
    GPUArrays.test(JLArray)
end

if haskey(ENV, "GITLAB_CI")
    @testset "CuArray" begin
        Pkg.test("CuArrays")
    end
end
